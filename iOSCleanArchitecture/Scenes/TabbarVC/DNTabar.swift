//
//  DNTabar.swift
//  iOSCleanArchitecture
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
}
