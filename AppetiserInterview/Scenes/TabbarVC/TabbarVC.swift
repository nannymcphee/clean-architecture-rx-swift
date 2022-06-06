//
//  TabbarVC.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit

struct DNTabbarItem {
    let title: String?
    let icon: UIImage?
}

class TabbarVC: UITabBarController {
    // MARK: - Variables
    public var tabbarItems: [DNTabbarItem] = [
        DNTabbarItem(title: "Home", icon: UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)),
        DNTabbarItem(title: "Favorites", icon: UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal)),
    ]
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = DNTabar(frame: tabBar.frame)
        setValue(tabbar, forKey: "tabBar")
        tabbar.configure()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = tabBar.items {
            items.forEach {
                $0.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            }
        }
    }
}

// MARK: - Extensions
extension TabbarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let index = viewControllers?.firstIndex(of: viewController) {
            let defaultsKey: DefaultsKey<Int> = index == 0 ? .lastVisitedMovieList : .lastVisitedFavorites
            Preferences[defaultsKey] = Int(Date().timeIntervalSince1970)
            Preferences[.lastTabIndex] = index
        }
    }
}
