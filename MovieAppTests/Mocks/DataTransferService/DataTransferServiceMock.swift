//
//  DataTransferServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class DataTransferServiceMock<GenericDecodable: Decodable>: DataTransferServiceProtocol {
    
    var requestCallsCount = 0
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue?

    func request(request: URLRequest, completion: @escaping (Result<GenericDecodable, DataTransferError>) -> Void) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        if let requestCompletionReturnValue = requestCompletionReturnValue {
            completion(requestCompletionReturnValue)
        }

        return URLSessionTask()
    }
}
