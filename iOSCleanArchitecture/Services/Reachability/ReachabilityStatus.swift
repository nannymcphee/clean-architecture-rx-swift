//
//  ReachabilityStatus.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 20/05/2022.
//

public enum ReachabilityStatus {
    case reachable(viaWiFi: Bool)
    case unreachable
}

extension ReachabilityStatus {
    var reachable: Bool {
        switch self {
        case .reachable:
            return true
        case .unreachable:
            return false
        }
    }
}
