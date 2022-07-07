//
//  DataTransferLoggerMock.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
@testable import MovieApp

class NetworkLoggerMock: NetworkLoggerProtocol {
    func log(_ request: URLRequest) {
        
    }
    
    func log(_ response: HTTPURLResponse) {
        let logToSave = Log(url: response.url!.absoluteString,
                            status: response.statusCode)
        
        self.logs.append(logToSave)
    }
    
    var mostRecentLog: Log?
    var logs: [Log] = []
}
