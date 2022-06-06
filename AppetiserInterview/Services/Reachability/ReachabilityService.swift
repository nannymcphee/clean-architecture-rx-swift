//
//  ReachabilityService.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 20/05/2022.
//

import RxSwift
import RxRelay
import Reachability

protocol ReachabilityService {
    var reachability: Observable<ReachabilityStatus> { get }
}

final class ReachabilityServiceImpl: ReachabilityService {
    // MARK: - Variables
    private let _reachabilityRelay: BehaviorRelay<ReachabilityStatus>
    private let _reachability: Reachability
    
    var reachability: Observable<ReachabilityStatus> {
        _reachabilityRelay.asObservable()
    }
    
    // MARK: - Initializer
    init() throws {
        guard let reachabilityRef = try? Reachability() else { throw ReachabilityServiceError.failedToCreate }
        let reachabilityRelay = BehaviorRelay<ReachabilityStatus>(value: .unreachable)
        let backgroundQueue = DispatchQueue(label: "reachability.wificheck")

        switch reachabilityRef.connection {
        case .cellular, .wifi:
            reachabilityRelay.accept(.reachable(viaWiFi: reachabilityRef.connection == .wifi))
        default:
            reachabilityRelay.accept(.unreachable)
        }
        
        reachabilityRef.whenReachable = { _ in
            backgroundQueue.async {
                reachabilityRelay.accept(.reachable(viaWiFi: reachabilityRef.connection == .wifi))
            }
        }

        reachabilityRef.whenUnreachable = { _ in
            backgroundQueue.async {
                reachabilityRelay.accept(.unreachable)
            }
        }
        
        try reachabilityRef.startNotifier()
        _reachability = reachabilityRef
        _reachabilityRelay = reachabilityRelay
    }
    
    // MARK: - Deinitializer
    deinit {
        _reachability.stopNotifier()
    }
}
