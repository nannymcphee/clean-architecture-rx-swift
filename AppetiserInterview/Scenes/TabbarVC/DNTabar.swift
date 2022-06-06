//
//  DNTabar.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit

class DNTabar: UITabBar {
    // MARK: - Variables
    private let heightTabBar: CGFloat = 60
    
    // MARK: - Overrides
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIWindow.key else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        if heightTabBar > 0.0 {
            if #available(iOS 13.0, *) {
                sizeThatFits.height = heightTabBar + window.safeAreaInsets.bottom
            } else {
                sizeThatFits.height = heightTabBar
            }
        }
        return sizeThatFits
    }
    
    // MARK: - Public functions
    public func configure() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.standardAppearance = appearance
    }
    
    public func setTheme(backgroundColor: UIColor = .red,
                         tabBarSeparator: UIColor = .red,
                         tintColor: UIColor,
                         selected: UIColor) {
        
        layer.shadowOffset = CGSize(width: 0, height: -1)
        layer.shadowRadius = 0
        layer.shadowColor = tabBarSeparator.cgColor
        layer.shadowOpacity = 0.8
        
        
        if #available(iOS 13, *) {
            self.standardAppearance.backgroundColor = backgroundColor
            self.tintColor = tintColor
            
        } else {
            self.isTranslucent = false
            self.backgroundImage = UIImage()
            self.shadowImage = UIImage()
            self.barTintColor = backgroundColor
            self.tintColor = tintColor
            
        }
        
        self.items?.forEach({ (item) in
            item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)], for: .normal)
            item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                                         NSAttributedString.Key.foregroundColor: selected], for: .selected)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            
            guard #available(iOS 13, *) else {
                item.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
                return
            }
        })
    }
}
