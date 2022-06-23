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

class MovieListCoordinator: NavigationCoordinator<MovieListRoute> {
    // MARK: - Initialization
    init(navigation: UINavigationController? = nil) {
        let nav = navigation ?? SwipeBackNavigationController()
        super.init(rootViewController: nav, initialRoute: .list)
    }
    
    // MARK: - Variables
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
}
