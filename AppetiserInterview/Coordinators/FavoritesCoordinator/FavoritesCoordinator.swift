//
//  FavoritesCoordinator.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import XCoordinator
import DNDomain
import Resolver

enum FavoritesRoute: Route {
    case main
    case movieDetail(Movie)
    case pop
}

class FavoritesCoordinator: NavigationCoordinator<FavoritesRoute>, EventPublishable {
    // MARK: Initialization
    init() {
        super.init(initialRoute: .main)
    }
    
    // MARK: - Event
    enum Event {
        /// Notifies update favorite status in Favorites and Detail screen
        case removeFromFavorite(Movie)
    }
    
    // MARK: - Variables
    public var eventPublisher = PublishSubject<Event>()
    private let disposeBag = DisposeBag()
    private var favoritesVM: FavoritesVM?
    private var movieDetailVM: MovieDetailVM?
    
    // MARK: Overrides
    override func prepareTransition(for route: FavoritesRoute) -> NavigationTransition {
        switch route {
        case .main:
            let movieRepo = Resolver.resolve(MovieRepo.self)
            favoritesVM = FavoritesVM(movieRepo: movieRepo)
            let vc = FavoritesVC(viewModel: favoritesVM!)
            
            favoritesVM?.eventPublisher
                .subscribe(with: self, onNext: { parent, event in
                    switch event {
                    case .movieDetail(let movie):
                        parent.trigger(.movieDetail(movie))
                    case .removeFromFavorite(let movie):
                        parent.eventPublisher.onNext(.removeFromFavorite(movie))
                    }
                })
                .disposed(by: disposeBag)
            
            return .push(vc)
            
        case .movieDetail(let movie):
            let movieRepo = Resolver.resolve(MovieRepo.self)
            movieDetailVM = MovieDetailVM(movie: movie, movieRepo: movieRepo)
            let vc = MovieDetailVC(viewModel: movieDetailVM!)
            
            movieDetailVM?.eventPublisher
                .subscribe(with: self, onNext: { parent, event in
                    switch event {
                    case .didToggleFavorite(let movie):
                        parent.favoritesVM?.removeFromFavorite(movie)
                        parent.eventPublisher.onNext(.removeFromFavorite(movie))
                    case .back:
                        parent.trigger(.pop)
                    }
                })
                .disposed(by: disposeBag)
            
            return .push(vc)
            
        case .pop:
            return .pop()
        }
    }
    
    public func updateFavoriteMovieFromDetail(_ movie: Movie) {
        movieDetailVM?.updateMovie(movie)
    }
}
