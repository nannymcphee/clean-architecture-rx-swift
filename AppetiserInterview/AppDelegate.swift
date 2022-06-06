//
//  AppDelegate.swift
//  AppetiserInterview
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
        // Override point for customization after application launch.
        setUpRouter()
        setUpNavigationBarTheme()
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
}

