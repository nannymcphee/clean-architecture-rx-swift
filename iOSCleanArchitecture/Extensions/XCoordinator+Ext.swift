//
//  XCoordinator+Ext.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import XCoordinator

extension Transition {
    static func presentFullScreen(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable, animation: animation)
    }
    
    static func dismissAll() -> Transition {
        return Transition(presentables: [], animationInUse: nil) { rootViewController, options, completion in
            guard let presentedViewController = rootViewController.presentedViewController else {
                completion?()
                return
            }
            presentedViewController.dismiss(animated: options.animated) {
                Transition.dismissAll()
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }
}