//
//  MovieListVM.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import RxCocoa
import Resolver
import DNDomain

final class MovieListVM: BaseVM, ViewModelTransformable, ViewModelTrackable, EventPublishable {
    // MARK: - Input
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let refreshTrigger: Observable<Void>
        let viewWillAppearTrigger: Observable<Void>
        let movieSelectTrigger: Observable<MovieItem>
        let favoriteTrigger: Observable<Movie>
        let searchText: Observable<String?>
    }
    
    // MARK: - Output
    struct Output {
        let movieSections: Driver<[MovieSection]>
    }
    
    // MARK: - Events
    enum Event {
        case movieDetail(Movie)
    }
    
    // MARK: - Variables
    let loadingIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    public var eventPublisher = PublishSubject<Event>()
    public var isSearching: Bool = false
    
    private var initialSections: [MovieSection] = []
    private var updatingMovie: Movie?
    private let movieRepo: MovieRepo
    private let appNetworkConditioner: AppNetworkConditioner
    private let movieSectionsRelay = BehaviorRelay<[MovieSection]>(value: [])
    private let lastVisitedRelay = BehaviorRelay<String>(value: "")
    private let isReachableRelay = BehaviorRelay<Bool>(value: false)
    
    // MARK: - Initializers
    init(movieRepo: MovieRepo, appNetworkConditioner: AppNetworkConditioner) {
        self.movieRepo = movieRepo
        self.appNetworkConditioner = appNetworkConditioner
        self.appNetworkConditioner.start()
    }
    
    // MARK: - Public functions
    public func transform(input: Input) -> Output {
        // Initial load & Refresh
        Observable.merge(input.viewDidLoadTrigger, input.refreshTrigger)
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.movieRepo.getMovies()
                    .trackError(vm.errorTracker, action: .toast)
                    .trackActivity(vm.loadingIndicator)
                    .catchErrorJustComplete()
            }
            .withUnretained(self)
            .map { vm, movies -> [MovieSection] in
                let items = movies.map { MovieItem(movie: $0) }
                return [MovieSection(items: items, sectionTitle: vm.lastVisitedRelay.value)]
            }
            .do(onNext: { [weak self] sections in
                self?.initialSections = sections
            })
            .bind(to: movieSectionsRelay)
            .disposed(by: disposeBag)
        
        // Last visited
        input.viewWillAppearTrigger
            .withUnretained(self)
            .flatMap { vm, _ -> Observable<String> in
                let lastVisited = Date.convertTimestampToDateStr(Preferences[.lastVisitedMovieList],
                                                                 dateFormat: Date.formatddMMyyyyHHmm)
                return .just("Last visited: \(lastVisited)")
            }
            .distinctUntilChanged()
            .bind(to: lastVisitedRelay)
            .disposed(by: disposeBag)
        
        // Movie selected
        input.movieSelectTrigger
            .map { Event.movieDetail($0.movie) }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
        
        // Toggle favorite
        input.favoriteTrigger
            .do(onNext: { [weak self] movie in
                self?.updatingMovie = movie
            })
            .withUnretained(self)
            .flatMap { vm, movie -> Observable<Void> in
                vm.movieRepo.toggleFavorite(movie: movie, isFavorited: !movie.isFavorited)
            }
            .subscribe(with: self, onNext: { vm, _ in
                var updatedMovie = vm.updatingMovie
                updatedMovie?.toggleFavorite()
                if let updatedMovie = updatedMovie {
                    vm.updateFavorite(updatedMovie)
                }
            })
            .disposed(by: disposeBag)
        
        // Update favorite status when receive notification
        NotificationCenter.default.rx.notification(.updateFavoriteMovie)
            .compactMap { notification -> (trackId: Int, isFavorited: Bool)? in
                guard let userInfo = notification.userInfo,
                      let trackId = userInfo["trackId"] as? Int,
                      let isFavorited = userInfo["isFavorited"] as? Bool else { return nil }
                return (trackId, isFavorited)
            }
            .subscribe(with: self, onNext: { vm, data in
                let movies = vm.movieSectionsRelay.value.map(\.items).flatMap { $0 }.map(\.movie)
                if var movie = movies.first(where: { $0.trackID == data.trackId }) {
                    movie.isFavorited = data.isFavorited
                    vm.updateFavorite(movie)
                }
            })
            .disposed(by: disposeBag)
        
        // Network reachability
        appNetworkConditioner
            .isReachableObservable
            .bind(to: isReachableRelay)
            .disposed(by: disposeBag)
        
        // Search text
        input.searchText
            .throttle(.milliseconds(1300), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .withUnretained(self)
            .flatMapLatest { vm, searchText -> Observable<[Movie]> in
                let initialMovies = vm.initialSections.flatMap(\.items).map(\.movie)
                guard let searchText = searchText, !searchText.isEmpty else {
                    vm.isSearching = false
                    return .just(initialMovies)
                }
                
                vm.isSearching = true
                
                if vm.isReachableRelay.value {
                    // Trigger search from API if network is reachable
                    return vm.movieRepo.searchMovies(searchText: searchText)
                } else {
                    // Otherwise, trigger search from local database
                    return vm.movieRepo.searchMoviesLocal(searchText: searchText)
                }
            }
            .withUnretained(self)
            .map { vm, movies -> [MovieSection] in
                let items = movies.map { MovieItem(movie: $0) }
                return [MovieSection(items: items, sectionTitle: vm.lastVisitedRelay.value)]
            }
            .bind(to: movieSectionsRelay)
            .disposed(by: disposeBag)
        
        return Output(movieSections: movieSectionsRelay.asDriverOnErrorJustComplete())
    }
}

// MARK: - Private functions
private extension MovieListVM {
    func updateFavorite(_ movie: Movie) {
        let sections = movieSectionsRelay.value
        let updatedSections = updateFavorite(for: movie, in: sections)
        movieSectionsRelay.accept(updatedSections)
        
        // Update initialSections when toggle favorite while searching
        // initialSections will be used to restore the list after user finished searching
        if isSearching {
            initialSections = updateFavorite(for: movie, in: initialSections)
        }
    }
    
    func updateFavorite(for movie: Movie, in sections: [MovieSection]) -> [MovieSection] {
        var _sections = sections
        guard let sectionIndex = _sections.firstIndex(where: { section in
            section.items.firstIndex(where: { $0.movie.trackID == movie.trackID }) != nil
        }) else { return initialSections }
        
        let updatedItem = MovieItem(movie: movie)
        if let itemIndex = sections[sectionIndex].items.firstIndex(of: updatedItem) {
            _sections[sectionIndex].items[itemIndex] = updatedItem
        }
        
        return _sections
    }
}
