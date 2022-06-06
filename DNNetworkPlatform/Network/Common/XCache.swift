//
//  XCache.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public class XCache {
    
    private let userDefault = UserDefaults.standard
    private let serializer = XSerializer()
    
    public func save<T: Codable>(object: T, forKey key: String) {
        guard let data: Data = serializer.serializeData(data: object) else { return }
        userDefault.set(data, forKey: key)
    }
    
    public func save(data: Data, forKey key: String) {
        userDefault.set(data, forKey: key)
    }
    
    public func getData<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefault.data(forKey: key) else { return nil }
        return serializer.serializeJson(data: data)
    }
}
