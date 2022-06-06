//
//  Router.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
}

class Router<EndPoint: EndPointType>: NSObject, NetworkRouter, URLSessionDataDelegate {
    private var task: URLSessionTask?
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30.0
        config.timeoutIntervalForResource = config.timeoutIntervalForRequest * 2
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = route.timeoutInterval ?? 30.0
        config.timeoutIntervalForResource = config.timeoutIntervalForRequest * 2
        let session = URLSession(configuration: config)
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        let url = route.path != "" ? route.baseURL.appendingPathComponent(route.path) : route.baseURL
        var request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: route.timeoutInterval ?? 30.0)
        
        request.httpMethod = route.httpMethod.rawValue
        route.headers?.forEach({ (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        })
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestMultiPart(let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders):
                self.addAdditionalHeaders(additionHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
                break
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: MultipartFormData,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> XError? {
        // TODO: Recheck status codes logic
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return XError.unauthorized
        case 501...599: return XError.badRequest
        case 600: return XError.outdated
        default: return XError.internalError
        }
    }
}
