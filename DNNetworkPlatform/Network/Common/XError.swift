//
//  XError.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public enum XError: Error {
    case internalError
    case networkError
    case unauthorized
    case badRequest
    case outdated
    case resourceNotFoundlError
    case parsingError
    case noData
    case responseUnsuccessful(message: String?)
    case notExist
    case wrongPass
    case inActive
    case registered
    case otpNotMatch
    case duplicateEmail
    case addressbookAlready
    case requestOverLimit
    
    var localizedDescription: String {
        switch self {
        case .internalError: return "Internal server error"
        case .networkError: return "Network error"
        case .unauthorized: return "Token has expired or missing"
        case .badRequest: return "Bad request"
        case .outdated: return "The url you requested is outdated."
        case .resourceNotFoundlError: return "Resource not found"
        case .parsingError: return "Parsing Error"
        case .noData: return "No data"
        case .responseUnsuccessful(let message): return message ?? "(Error without message)"
        case .notExist: return "Not exist"
        case .wrongPass: return "Wrong password"
        case .inActive: return "Inactive"
        case .registered: return "Phone was Registered"
        case .otpNotMatch: return "Otp not match."
        case .duplicateEmail: return "Duplicate email."
        case .addressbookAlready: return "Addressbook already exist."
        case .requestOverLimit: return "Request over limit"
        }
    }
}
