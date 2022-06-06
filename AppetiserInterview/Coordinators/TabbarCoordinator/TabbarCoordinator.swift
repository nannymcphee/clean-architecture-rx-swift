//
//  TabbarCoordinator.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import XCoordinator
import RxSwift
import RxCocoa

enum TabbarRoute: Route {
    case movieList
    case favorites
}

class TabbarCoordinator: TabBarCoordinator<TabbarRoute> {
    // MARK: - Variables
    private let movieList: MovieListCoordinator
    private let favorites: FavoritesCoordinator
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    internal init(movieList: MovieListCoordinator,
                  favorites: FavoritesCoordinator) {
        self.movieList = movieList
        self.favorites = favorites
        
        let tabbarVC = TabbarVC()
        
        movieList.strongRouter.viewController.tabBarItem = UITabBarItem(title: tabbarVC.tabbarItems[0].title,
                                                                        image: tabbarVC.tabbarItems[0].icon?.withTintColor(.systemGray),
                                                                        selectedImage: tabbarVC.tabbarItems[0].icon?.withTintColor(.white))
        favorites.strongRouter.viewController.tabBarItem = UITabBarItem(title: tabbarVC.tabbarItems[1].title,
                                                                        image: tabbarVC.tabbarItems[1].icon?.withTintColor(.systemGray),
                                                                        selectedImage: tabbarVC.tabbarItems[1].icon?.withTintColor(.white))
        
        if Preferences[.lastTabIndex] == 0 {
            Preferences[.lastVisitedMovieList] = Int(Date().timeIntervalSince1970)
        } else {
            Preferences[.lastVisitedFavorites] = Int(Date().timeIntervalSince1970)
        }
        
        super.init(rootViewController: tabbarVC,
                   tabs: [movieList, favorites],
                   select: Preferences[.lastTabIndex])
        setUpBinding()
    }
    
    // MARK: - Overrides
    override func prepareTransition(for route: TabbarRoute) -> TabBarTransition {
        switch route {
        case .movieList:
            return .select(movieList)
        case .favorites:
            return .select(favorites)
        }
    }
    
    // MARK: - Private functions
    private func setUpBinding() {
        favorites.eventPublisher
            .subscribe(with: self, onNext: { parent, event in
                switch event {
                case .removeFromFavorite(let movie):
                    parent.movieList.handleRemoveFromFavorite(movie)
                }
            })
            .disposed(by: disposeBag)
        
        movieList.eventPublisher
            .subscribe(with: self, onNext: { parent, event in
                switch event {
                case .updateFavoriteFromDetail(let movie):
                    parent.favorites.updateFavoriteMovieFromDetail(movie)
                }
            })
            .disposed(by: disposeBag)
    }
}
