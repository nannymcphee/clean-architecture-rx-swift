//
//  XResult.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public enum XResult<T>{
    case success(T)
    case failure(XError)
}

public typealias XPagingResult<T: Codable>   = XResult<XPagingData<T>>
