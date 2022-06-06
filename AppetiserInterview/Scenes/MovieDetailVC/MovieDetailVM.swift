//
//  MovieDetailVM.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Resolver
import DNDomain

final class MovieDetailVM: BaseVM, ViewModelTransformable, EventPublishable {
    // MARK: - Input
    struct Input {
        let backTrigger: Observable<Void>
        let favoriteTrigger: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        let thumbnailURL: Driver<String>
        let movieName: Driver<String>
        let movieGerne: Driver<String>
        let moviePrice: Driver<String>
        let movieReleasedDate: Driver<String>
        let movieDescription: Driver<String>
        let isFavorited: Driver<Bool>
    }
    
    // MARK: - Event
    enum Event {
        case back
        case didToggleFavorite(Movie)
    }
    
    // MARK: - Variables
    public var eventPublisher = PublishSubject<Event>()
    
    private let movieRepo: MovieRepo
    private let movieRelay = BehaviorRelay<Movie?>(value: nil)
    
    // MARK: - Initializers
    public init(movie: Movie, movieRepo: MovieRepo) {
        self.movieRepo = movieRepo
        movieRelay.accept(movie)
    }
    
    // MARK: - Public functions
    func transform(input: Input) -> Output {
        let thumbnailURL = movieRelay.compactMap { $0?.artworkUrl1024 }
        let movieName = movieRelay.compactMap { $0?.trackName }
        let movieGerne = movieRelay.compactMap { $0?.primaryGenreName }
        let moviePrice = movieRelay.compactMap { movie -> String? in
            return "\(movie?.trackPrice ?? 0.0) " + (movie?.currency).orEmpty
        }
        let releasedDate = movieRelay.compactMap { movie -> String in
            let dateString = Date.convertDate(from: (movie?.releaseDate).orEmpty,
                                              currentFormat: Date.dateTimeZoneFormat,
                                              newFormat: Date.formatddMMyyyy)
            return "Released date: \(dateString)"
        }
        let movieDescription = movieRelay.compactMap { movie -> String? in
            guard movie?.longDescription.isEmpty == false else {
                return movie?.shortDescription
            }
            return movie?.longDescription
        }
        let isFavorited = movieRelay.compactMap(\.?.isFavorited)
        
        // Favorite trigger
        input.favoriteTrigger
            .withLatestFrom(movieRelay)
            .unwrap()
            .withUnretained(self)
            .flatMap { vm, movie -> Observable<Void> in
                vm.movieRepo.toggleFavorite(movie: movie, isFavorited: !movie.isFavorited)
            }
            .subscribe(with: self, onNext: { vm, _ in
                var currentMovie = vm.movieRelay.value
                currentMovie?.toggleFavorite()
                vm.movieRelay.accept(currentMovie)
                if let currentMovie = currentMovie {
                    vm.eventPublisher.onNext(.didToggleFavorite(currentMovie))
                }
            })
            .disposed(by: disposeBag)
        
        // Back trigger
        input.backTrigger
            .map { Event.back }
            .bind(to: eventPublisher)
            .disposed(by: disposeBag)
            
        return Output(thumbnailURL: thumbnailURL.asDriverOnErrorJustComplete(),
                      movieName: movieName.asDriverOnErrorJustComplete(),
                      movieGerne: movieGerne.asDriverOnErrorJustComplete(),
                      moviePrice: moviePrice.asDriverOnErrorJustComplete(),
                      movieReleasedDate: releasedDate.asDriverOnErrorJustComplete(),
                      movieDescription: movieDescription.asDriverOnErrorJustComplete(),
                      isFavorited: isFavorited.asDriverOnErrorJustComplete())
    }
    
    public func updateMovie(_ movie: Movie) {
        self.movieRelay.accept(movie)
    }
}
