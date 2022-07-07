//
//  DataTransferLoggerMock.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
@testable import MovieApp

class NetworkLoggerMock: NetworkLoggerProtocol {
    
    // MARK: - log(_ request: URLRequest)
    
    func log(_ request: URLRequest) {
        
    }
    
    
    
    // MARK: - log(_ response: HTTPURLResponse)
    
    var logResponseCallCount: Int = 0
    
    // response
    var logResponseParameterReceived: HTTPURLResponse?
    
    var mostRecentLog: Log?
    var logs: [Log] = []

    func log(_ response: HTTPURLResponse) {
        self.logResponseCallCount += 1
        self.logResponseParameterReceived = response
    }
}
