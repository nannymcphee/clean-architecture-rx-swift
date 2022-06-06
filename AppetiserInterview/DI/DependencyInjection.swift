//
//  DependencyInjection.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Resolver
import RxSwift
import DNDomain
import DNNetworkPlatform
import DNRealmPlatform

extension Resolver: ResolverRegistering {
    /// Inject all services
    public static func registerAllServices() {
        registerConfigService()
        registerNetworkService()
        registerDispatchQueue()
        registerRealmService()
        registerMovieRepo()
        registerReachabilityService()
        registerAppNetworkConditioner()
    }
}

extension Resolver {
    /// Inject server config
    private static func registerConfigService() {
        register { ServerConfig.testing as ServerConfigType }
            .scope(.cached)
    }
    
    /// Inject NetworkPlatform
    private static func registerNetworkService() {
        // Register UseCaseProvider
        register {
            DNNetworkPlatform.UseCaseProviderImpl(
                config: resolve() as ServerConfigType
            )  as DNNetworkPlatform.UseCaseProvider
        }
        .scope(.cached)
        
        // Register MovieUseCase
        register { () -> DNNetworkPlatform.MovieUseCase in
            let provider = resolve() as DNNetworkPlatform.UseCaseProvider
            return provider.makeMovieUseCase()
        }
        .scope(.cached)
    }
    
    /// Register MovieRepo
    private static func registerMovieRepo() {
        register {
            MovieRepoImpl() as MovieRepo
        }.scope(.cached)
    }
    
    /// Register Realm
    private static func registerRealmService() {
        register { () -> DNRealmPlatform.UseCaseProvider? in
            let config = resolve() as ServerConfigType
            return DNRealmPlatform.UseCaseProviderImpl(databaseIdentifier: config.databaseIdentifer,
                                                       schemaVersion: config.databaseVersion) as DNRealmPlatform.UseCaseProvider
        }
        .scope(.cached)
        
        // Register MovieUseCase
        register { () -> DNRealmPlatform.MovieUseCase in
            let provider = resolve() as DNRealmPlatform.UseCaseProvider
            return provider.makeMovieUseCase()
        }
        .scope(.cached)
    }
    
    /// Register DispatchQueue
    private static func registerDispatchQueue() {
        register { () -> DispatchQueue in
            let config = resolve() as ServerConfigType
            return DispatchQueue(
                label: config.appIdentifier,
                qos: .userInteractive,
                attributes: .concurrent,
                autoreleaseFrequency: .workItem, target: nil
            )
        }
        .scope(.cached)
        
        register { () -> ConcurrentDispatchQueueScheduler in
            let workingQueue = resolve() as DispatchQueue
            return ConcurrentDispatchQueueScheduler(queue: workingQueue)
        }
        .scope(.cached)
        
        register { () -> OperationQueueScheduler in
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 2
            return OperationQueueScheduler(operationQueue: queue)
        }
        .scope(.cached)
    }
    
    /// Register Reachability
    private static func registerReachabilityService() {
        register { () -> ReachabilityService? in
            return try? ReachabilityServiceImpl() as ReachabilityService
        }
        .scope(.cached)
    }
    
    /// Register AppNetwork
    private static func registerAppNetworkConditioner() {
        register { () -> AppNetworkConditioner in
            return AppNetworkConditionerImpl(service: resolve() as ReachabilityService)
        }
    }
}

// MARK: Utils
extension DNNetworkPlatform.UseCaseProviderImpl {
    convenience init(config: ServerConfigType) {
        self.init(config: BuildConfig(baseURL: config.serverUrl))
    }
}
