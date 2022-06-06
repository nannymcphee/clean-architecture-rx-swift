//
//  BuildConfig.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public struct BuildConfig {
    
    public var baseURL: URL
    public var token: String?
    
    public init(baseURL: URL,
                token: String? = nil) {
        self.baseURL = baseURL
        self.token = token
    }
    
    static var `default` = BuildConfig(
        baseURL: URL(string: "https://itunes.apple.com")!,
        token: nil
    )
}
