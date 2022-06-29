//
//  NetworkServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 29/06/2022.
//

import Foundation
@testable import MovieApp

class NetworkServiceMock: NetworkServiceProtocol {
    
    // MARK: - request
    
    var requestCallsCount = 0
    var requestReturnValue: URLSessionTask? = URLSessionTask()
        
    // completion
    var requestCompletionReturnValue: ResultValue = .success([])

    func request(_ request: NetworkRequest, completion: CompletionHandler) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        completion(requestCompletionReturnValue)
        
        return requestReturnValue
    }
}
