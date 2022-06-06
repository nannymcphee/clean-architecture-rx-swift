//
//  NFontProtocol.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 18/03/2022.
//

import UIKit

protocol NFontProtocol {
    func light(_ size: CGFloat) -> UIFont
    func regular(_ size: CGFloat) -> UIFont
    func medium(_ size: CGFloat) -> UIFont
    func semiBold(_ size: CGFloat) -> UIFont
    func bold(_ size: CGFloat) -> UIFont
}

extension NFontProtocol {
    func light(_ size: CGFloat) -> UIFont { return .systemFont(ofSize: size) }
    func bold(_ size: CGFloat) -> UIFont { return .systemFont(ofSize: size) }
    func semiBold(_ size: CGFloat) -> UIFont { return .systemFont(ofSize: size) }
}
