//
//  AppCoordinator.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import XCoordinator
import Resolver

enum AppRoute: Route {
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    // MARK: - Variables
    private var tabbarCoordinator: TabbarCoordinator?
    
    // MARK: - Initialization
    init() {
        super.init(initialRoute: .main)
    }
    
    // MARK: - Overrides
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .main:
            tabbarCoordinator = TabbarCoordinator(movieList: MovieListCoordinator(),
                                                  favorites: FavoritesCoordinator())
            return .multiple(.dismissAll(),
                             .presentFullScreen(tabbarCoordinator!.strongRouter))
        }
    }
}

