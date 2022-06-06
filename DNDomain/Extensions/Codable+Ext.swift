//
//  Codable+Ext.swift
//  DNDomain
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

extension KeyedDecodingContainer {
    func decodex<T>(key: K, defaultValue: T) -> T
        where T : Decodable {
            return (try? decode(T.self, forKey: key)) ?? defaultValue
    }
}
