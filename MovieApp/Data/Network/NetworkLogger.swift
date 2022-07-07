//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Paul on 06/07/2022.
//

import Foundation

protocol NetworkLoggerProtocol {
//    func log(_ request: URLRequest)
    func log(_ response: HTTPURLResponse)
}

class NetworkLogger {
    var logs: [Log] = []
}


// MARK: - NetworkLoggerProtocol

extension NetworkLogger: NetworkLoggerProtocol {
    func log(_ request: URLRequest) {
        
    }
    
    func log(_ response: HTTPURLResponse) {
        let logToSave = Log(url: response.url!.absoluteString,
                            status: response.statusCode)
        
        self.logs.append(logToSave)
    }
}

struct Log: Equatable {
    let url: String
    let status: Int
}


protocol NetworkResponse {
    
}

extension HTTPURLResponse: NetworkResponse {
    
}
