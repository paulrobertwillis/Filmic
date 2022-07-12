//
//  DataTransferServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class GenresDataTransferMock: DataTransferService<GenresResponseDTO> {
    
    // MARK: - Lifecycle
    
    init() {
        super.init(networkService: NetworkServiceMock())
    }
    
    // MARK: - request(request, completion)
    
    var requestCallsCount = 0
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue?

    override func request(_ request: URLRequest, completion: @escaping (Result<GenericDecodable, DataTransferError>) -> Void) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        if let requestCompletionReturnValue = requestCompletionReturnValue {
            completion(requestCompletionReturnValue)
        }

        return URLSessionTask()
    }

}
