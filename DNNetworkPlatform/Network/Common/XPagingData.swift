//
//  XPagingData.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public struct XPagingData<T: Codable>: Codable {
    let resultCount: Int
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = values.decodex(key: .resultCount, defaultValue: 0)
        results = values.decodex(key: .results, defaultValue: [])
    }
}
