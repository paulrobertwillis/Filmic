//
//  DataTransferServiceMock.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation
@testable import MovieApp

class DataTransferServiceMock: DataTransferServiceProtocol {
    
    var requestCallsCount = 0
    
    // completion parameter
    var requestCompletionReturnValue: ResultValue = .success(GenresResponseDTO(genres: []))

    func request<T: Decodable>(request: URLRequest, completion: CompletionHandler<T>) -> URLSessionTask? {
        self.requestCallsCount += 1
        
        completion(requestCompletionReturnValue)

        return URLSessionTask()
    }
}
