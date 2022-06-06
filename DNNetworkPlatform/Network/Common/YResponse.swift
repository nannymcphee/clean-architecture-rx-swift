//
//  YResponse.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit

public class YResponse<T: Codable>: Codable {
    public var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = values.decodex(key: .data, defaultValue: nil)
    }
}
