//
//  MovieListCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import XCoordinator
import DNDomain
import Resolver

enum MovieListRoute: Route {
    case list
    case movieDetail(Movie)
    case pop
}

class MovieListCoordinator: NavigationCoordinator<MovieListRoute>, EventPublishable {
    // MARK: - Initialization
    init(navigation: UINavigationController? = nil) {
        let nav = navigation ?? SwipeBackNavigationController()
        super.init(rootViewController: nav, initialRoute: .list)
    }
    
    // MARK: - Event
    enum Event {
        /// Notifies update favorite status in Detail screen
        case updateFavoriteFromDetail(Movie)
    }
    
    // MARK: - Variables
    public var eventPublisher = PublishSubject<Event>()
    private let disposeBag = DisposeBag()
    private var movieListVM: MovieListVM?
    private var movieDetailVM: MovieDetailVM?
    
    // MARK: - Overrides
    override func prepareTransition(for route: MovieListRoute) -> NavigationTransition {
        switch route {
        case .list:
            let movieRepo = Resolver.resolve(MovieRepo.self)
            let appNetworkConditioner = Resolver.resolve(AppNetworkConditioner.self)
            movieListVM = MovieListVM(movieRepo: movieRepo,
                                      appNetworkConditioner: appNetworkConditioner)
            let vc = MovieListVC(viewModel: movieListVM!)
            
            movieListVM?.eventPublisher
                .subscribe(with: self, onNext: { parent, event in
                    switch event {
                    case .movieDetail(let movie):
                        parent.trigger(.movieDetail(movie))
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
                        parent.movieListVM?.updateFavorite(movie)
                        parent.eventPublisher.onNext(.updateFavoriteFromDetail(movie))
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
    
    // MARK: - Public functions
    public func handleRemoveFromFavorite(_ movie: Movie) {
        movieListVM?.updateFavorite(movie)
        movieDetailVM?.updateMovie(movie)
    }
}
