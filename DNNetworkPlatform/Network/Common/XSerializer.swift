//
//  XSerializer.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

protocol TPSerializable {
    func serializeJson<T: Codable>(data: Data) -> T?
    func serializeData<T: Codable>(data: T) -> Data?
}

public class XSerializer: TPSerializable {
    
    func serializeJson<T: Codable>(data: Data) -> T? {
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func serializeData<T: Codable>(data: T) -> Data? {
        return try? JSONEncoder().encode(data)
    }
}
