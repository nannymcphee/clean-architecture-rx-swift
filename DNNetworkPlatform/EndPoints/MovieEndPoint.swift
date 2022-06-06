//
//  MovieEndPoint.swift
//  DNNetworkPlatform
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

public enum MovieEndPoint {
    case getMovieList
    case searchMovies(String)
}

extension MovieEndPoint: EndPointType {
    public var baseURL: URL {
        return BuildConfig.default.baseURL
    }
    
    public var path: String {
        switch self {
        case .getMovieList, .searchMovies:
            return "/search"
        }
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
    
    public var timeoutInterval: Double? {
        return 30.0
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var task: HTTPTask {
        switch self {
        case .getMovieList:
            var params = Parameters()
            params[JSONKeys.term] = "star"
            params[JSONKeys.country] = "au"
            params[JSONKeys.media] = "movie"
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
            
        case .searchMovies(let searchText):
            var params = Parameters()
            params[JSONKeys.term] = searchText
            params[JSONKeys.country] = "au"
            params[JSONKeys.media] = "movie"
            params[JSONKeys.limit] = "\(20)"
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
        }
    }
}
