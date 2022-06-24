//
//  AppDelegate.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import Resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private let router = AppCoordinator().strongRouter
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpRouter()
        setUpNavigationBarTheme()
        setUpTableViewAppearance()
        // Dependency Injection
        Resolver.registerAllServices()
        return true
    }

    private func setUpRouter() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .dark
        window?.backgroundColor = .black
        if let window = window {
            router.setRoot(for: window)
        }
    }
    
    private func setUpNavigationBarTheme() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    }
    
    private func setUpTableViewAppearance() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
}

