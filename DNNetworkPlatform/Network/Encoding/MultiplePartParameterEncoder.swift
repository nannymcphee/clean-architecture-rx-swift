//
//  MultiplePartParameterEncoder.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import UIKit

class MultiplePartParameterEncoder: NSObject {
    public func encode(urlRequest: inout URLRequest, with parameters: MultipartFormData) throws {
        urlRequest.httpBody = try parameters.encode()
        urlRequest.setValue("no-cache", forHTTPHeaderField: "cache-control")
        urlRequest.setValue("multipart/form-data; boundary=\(parameters.boundary)", forHTTPHeaderField: "content-type")
    }
}
