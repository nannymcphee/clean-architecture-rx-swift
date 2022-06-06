//
//  UIWindow+Ext.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
