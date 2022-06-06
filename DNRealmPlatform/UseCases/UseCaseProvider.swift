//
//  UseCaseProvider.swift
//  DNRealmPlatform
//
//  Created by Duy Nguyen on 30/05/2022.
//

import Foundation
import RealmSwift
import RxSwift

public protocol UseCaseProvider {
    func makeMovieUseCase() -> MovieUseCase
}

public final class UseCaseProviderImpl: UseCaseProvider {
    // MARK: - Variables
    private let configuration: Realm.Configuration
    private let tempConfiguration: Realm.Configuration
    private let excutionQueue: DispatchQueue
    public static let defaultExcuteQueue: DispatchQueue = DispatchQueue(
        label: "com.duynn.realm",
        qos: .userInteractive,
        attributes: [.concurrent],
        autoreleaseFrequency: .workItem
    )
    
    //MARK: - REALM CONFIG
    /// MigrationBlock
    private static var migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
        
    }
    
    /// StorageLocation
    /// - Path of database
    private static func storageLocationFor(databaseIdentifier: String) -> URL? {
        return Realm.Configuration.defaultConfiguration.fileURL?.deletingLastPathComponent().appendingPathComponent(databaseIdentifier)
    }

    // MARK: - Initializer
    public init(databaseIdentifier: String, schemaVersion: UInt64, excutionQueue: DispatchQueue = defaultExcuteQueue) {
        self.configuration = Realm.Configuration(
            fileURL       : UseCaseProviderImpl.storageLocationFor(databaseIdentifier: databaseIdentifier),
            schemaVersion : schemaVersion,
            migrationBlock: UseCaseProviderImpl.migrationBlock
        )
        self.tempConfiguration = Realm.Configuration(
            fileURL       : UseCaseProviderImpl.storageLocationFor(databaseIdentifier: "temp.realm"),
            schemaVersion : schemaVersion,
            migrationBlock: UseCaseProviderImpl.migrationBlock
        )
        self.excutionQueue = excutionQueue
    }
    
    // MARK: - Public functions
    public func makeMovieUseCase() -> MovieUseCase {
        return MovieUseCaseImpl(configuration: configuration, excutionQueue: excutionQueue)
    }
}
