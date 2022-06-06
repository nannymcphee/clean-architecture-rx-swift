//
//  XDecodingManager.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

extension KeyedDecodingContainer {
    func decodex<T>(key: K, defaultValue: T) -> T
        where T : Decodable {
            return (try? decode(T.self, forKey: key)) ?? defaultValue
    }
}
