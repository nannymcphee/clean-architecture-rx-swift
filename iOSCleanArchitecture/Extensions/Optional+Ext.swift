//
//  Optional+Ext.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

public extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        default:
            return ""
        }
    }
}
