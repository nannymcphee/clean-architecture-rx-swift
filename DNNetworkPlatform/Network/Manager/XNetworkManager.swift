//
//  NetworkManager.swift
//  NNetworkPlatform
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

public typealias XNetworkCompletion<T>   = (XResult<T>) -> ()

public class XNetworkManager<E: EndPointType> {
    
    let router = Router<E>()
    
    // Serializer
    private let serializer = XSerializer()
    private let completionQueue: DispatchQueue = DispatchQueue.main
    
    public func request<T: Codable>(target: E, completion: XNetworkCompletion<T>?) {
        let completionQueue = self.completionQueue
        
        router.request(target) { (data, response, error) in
            if error != nil {
                completionQueue.async { completion?(XResult.failure(XError.networkError)) }
                XLog.print(error?.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if let responseErr = self.handleNetworkResponse(response) {
                    completionQueue.async { completion?(XResult.failure(responseErr)) }
                } else {
                    guard let responseData = data else {
                        completionQueue.async { completion?(XResult.failure(XError.internalError)) }
                        return
                    }
                    
                    // Serialize data
                    guard let parsedData: T = self.serializer.serializeJson(data: responseData) else {
                        completionQueue.async { completion?(XResult.failure(XError.parsingError)) }
                        return
                    }

                    completionQueue.async { completion?(XResult.success(parsedData)) }
                }
            } else {
                completionQueue.async { completion?(XResult.failure(XError.internalError)) }
            }
        }
    }
    
    public func requestRaw<T: Codable>(target: E, completion: XNetworkCompletion<T>?) {
        let completionQueue = self.completionQueue
        
        router.request(target) { (data, response, error) in
            if error != nil {
                completionQueue.async { completion?(XResult.failure(XError.networkError)) }
                XLog.print(error?.localizedDescription)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if let responseErr = self.handleNetworkResponse(response) {
                    completionQueue.async { completion?(XResult.failure(responseErr)) }
                } else {
                    guard let responseData = data else {
                        completionQueue.async { completion?(XResult.failure(XError.internalError)) }
                        return
                    }
                    
                    // Serialize data
                    guard let parsedData: T = responseData as? T else {
                        completionQueue.async { completion?(XResult.failure(XError.parsingError)) }
                        return
                    }
                    
                    completionQueue.async { completion?(XResult.success(parsedData)) }
                }
            } else {
                completionQueue.async { completion?(XResult.failure(XError.internalError)) }
            }
        }
    }
    
    public func requestLocal<T: Codable>(fileName: String, completion: XNetworkCompletion<T>?) {
        self.getDataFromFile(fileName: fileName, completion: completion)
    }
}

extension XNetworkManager {
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> XError? {
        switch response.statusCode {
        case 200...299: return nil
        case 401...500: return XError.unauthorized
        case 501...599: return XError.badRequest
        case 600: return XError.outdated
        default: return XError.internalError
        }
    }
    
    fileprivate func dataFromJsonFile(fileName: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            return NSData(contentsOfFile: path) as Data?
        }
        return nil
    }
    
    fileprivate func getDataFromFile<T: Codable>(fileName: String, completion: XNetworkCompletion<T>?) {
        if let data = dataFromJsonFile(fileName: fileName) {
            // Serialize data
            guard let parsedData: XResponse<T> = self.serializer.serializeJson(data: data) else {
                completionQueue.async { completion?(XResult.failure(XError.internalError)) }
                return
            }
            
            // Check response status
//            guard parsedData.status == 1 else {
//                completionQueue.async { completion?(XResult.failure(XError.responseUnsuccessful(message: parsedData.message))) }
//                return
//            }
            
            // Check response data
            guard let finalData = parsedData.data else {
                completionQueue.async { completion?(XResult.failure(XError.noData)) }
                return
            }
            
            completionQueue.async { completion?(XResult.success(finalData)) }
        } else {
            completionQueue.async { completion?(XResult.failure(XError.internalError)) }
        }
    }
}
