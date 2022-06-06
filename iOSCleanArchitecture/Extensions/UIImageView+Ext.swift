//
//  UIImageView+Ext.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import UIKit
import Kingfisher

extension UIImageView {
    public func setImage(url: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: url) else {
            self.image = placeholder
            return
        }
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
    }
    
    public func cancelDownloadTask() {
        self.kf.cancelDownloadTask()
    }
}
