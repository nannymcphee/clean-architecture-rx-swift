//
//  MovieListResponse.swift
//  DNDomain
//
//  Created by Duy Nguyen on 20/05/2022.
//

import Foundation

public struct MovieListResponse: Codable {
    public let resultCount: Int
    public let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount, results
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = values.decodex(key: .resultCount, defaultValue: 0)
        results = values.decodex(key: .results, defaultValue: [])
    }
}
