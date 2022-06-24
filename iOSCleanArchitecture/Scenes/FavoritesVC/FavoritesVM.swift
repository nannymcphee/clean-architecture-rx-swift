//
//  FavoritesVM.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import RxCocoa
import Resolver
import DNDomain

final class FavoritesVM: BaseVM, ViewModelTransformable, ViewModelTrackable, EventPublishable {
    // MARK: - Input
    struct Input {
        let viewWillAppearTrigger: Observable<Void>
        let refreshTrigger: Observable<Void>
        let movieSelectTrigger: Observable<MovieItem>
        let favoriteTrigger: Observable<Movie>
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
    public let loadingIndicator = ActivityIndicator()
    public let errorTracker = ErrorTracker()
    public var eventPublisher = PublishSubject<Event>()
    
    private var updatingMovie: Movie?
    private let movieRepo: MovieRepo
    private let movieSectionsRelay = BehaviorRelay<[MovieSection]>(value: [])
    private let lastVisitedRelay = BehaviorRelay<String>(value: "")
    
    // MARK: - Initialziers
    public init(movieRepo: MovieRepo) {
        self.movieRepo = movieRepo
    }
    
    // MARK: - Public functions
    func transform(input: Input) -> Output {
        let viewWillAppearShared = input.viewWillAppearTrigger.share()
        // Initial load & Refresh
        Observable.merge(viewWillAppearShared, input.refreshTrigger)
            .withUnretained(self)
            .flatMapLatest { vm, _ in
                vm.movieRepo.getFavoriteMovies()
                    .track(activityIndicator: vm.loadingIndicator, errorTracker: vm.errorTracker, action: .toast)
                    .catchErrorJustComplete()
            }
            .withUnretained(self)
            .map { vm, movies -> [MovieSection] in
                let items = movies.map { MovieItem(movie: $0) }
                return [MovieSection(items: items, sectionTitle: vm.lastVisitedRelay.value)]
            }
            .bind(to: movieSectionsRelay)
            .disposed(by: disposeBag)
        
        // Last visited
        viewWillAppearShared
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
                    NotificationCenter.default.post(name: .updateFavoriteMovie, object: nil, userInfo: ["trackId": updatedMovie.trackID,
                                                                                                        "isFavorited": updatedMovie.isFavorited])
                    vm.removeFromFavorite(updatedMovie)
                }
            })
            .disposed(by: disposeBag)
        
        // Remove favorite movie when receive notification
        NotificationCenter.default.rx.notification(.updateFavoriteMovie)
            .compactMap { notification -> Int? in
                guard let userInfo = notification.userInfo else { return nil }
                return userInfo["trackId"] as? Int
            }
            .subscribe(with: self, onNext: { vm, trackId in
                let movies = vm.movieSectionsRelay.value.map(\.items).flatMap { $0 }.map(\.movie)
                if let movie = movies.first(where: { $0.trackID == trackId }) {
                    vm.removeFromFavorite(movie)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(movieSections: movieSectionsRelay.asDriverOnErrorJustComplete())
    }
}

private extension FavoritesVM {
    func removeFromFavorite(_ movie: Movie) {
        var sections = movieSectionsRelay.value
        
        guard let sectionIndex = sections.firstIndex(where: { section in
            section.items.firstIndex(where: { $0.movie.trackID == movie.trackID }) != nil
        }) else { return }
        
        if let itemIndex = sections[sectionIndex].items.firstIndex(where: { $0.movie.trackID == movie.trackID }) {
            sections[sectionIndex].items.remove(at: itemIndex)
        }
        
        movieSectionsRelay.accept(sections)
    }
}
