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
    
    func log(_ request: NetworkRequest) {
        
    }
    
    
    
    // MARK: - log(_ response: HTTPURLResponse)
    
    var logResponseCallCount: Int = 0
    
    // response
    var logResponseParameterReceived: NetworkResponse?
    
    // withError
    var logWithErrorParameterReceived: Error?
    
    var mostRecentLog: Log?
    var logs: [Log] = []

    func log(_ response: NetworkResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: NetworkResponse, withError error: Error?) {
        self.logResponseCallCount += 1
        self.logResponseParameterReceived = response
    }
}
