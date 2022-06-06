//
//  XResponse.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public class XResponse<T: Codable>: Codable {
    public var status: Int
    public var message: String
    public var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case status = "code"
        case message = "msg"
        case data = "data"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = values.decodex(key: .status, defaultValue: -1)
        message = values.decodex(key: .message, defaultValue: "")
        data = values.decodex(key: .data, defaultValue: nil)
    }
}

