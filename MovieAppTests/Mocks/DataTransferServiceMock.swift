//
//  DataTransferServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class DataTransferServiceMock<T: Decodable>: DataTransferServiceProtocol {
    
    var requestCallsCount = 0
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue?

    func request(request: URLRequest, completion: @escaping (Result<T, DataTransferError>) -> Void) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        guard let requestCompletionReturnValue = requestCompletionReturnValue else {
            return URLSessionTask()
        }

        completion(requestCompletionReturnValue)

        return URLSessionTask()
    }
}
