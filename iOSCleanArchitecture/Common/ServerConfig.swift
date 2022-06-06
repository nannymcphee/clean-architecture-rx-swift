//
//  ServerConfig.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

public protocol ServerConfigType {
    var serverUrl: URL { get }
    var appIdentifier: String { get }
    var databaseIdentifer: String { get }
    var databaseVersion: UInt64 { get }
}

public class ServerConfig: ServerConfigType {
    public init(serverUrl: URL,
                appIdentifier: String,
                databaseIdentifer: String,
                databaseVersion: UInt64,
                environment: EnvironmentType) {
        self.serverUrl = serverUrl
        self.appIdentifier = appIdentifier
        self.databaseIdentifer = databaseIdentifer
        self.databaseVersion = databaseVersion
        self.environment = environment
    }
    
    public var serverUrl: URL
    public var appIdentifier: String
    public var databaseIdentifer: String
    public var databaseVersion: UInt64
    public var environment: EnvironmentType
    
    public static let testing = ServerConfig(
        serverUrl:          URL(string: "https://itunes.apple.com")!,
        appIdentifier:      "com.duynn.iOSCleanArchitecture",
        databaseIdentifer:  "default.realm",
        databaseVersion:    1,
        environment:        .testing
    )
}
