//
//  GenresResponseStorageMock.swift
//  MovieAppTests
//
//  Created by Paul on 13/07/2022.
//

import Foundation
@testable import MovieApp

class GenresResponseStorageMock: GenresResponseStorageProtocol {

    // MARK: - getResponse()
    
    public var getResponseCallCount = 0
    
    // request parameter
    var getResponseReceivedRequest: URLRequest?
    
    // completion parameter
    var getResponseCompletionReturnValue: ResultValue?
    
    func getResponse(for request: URLRequest, completion: @escaping GenresResponseStorageCompletionHandler) {
        self.getResponseCallCount += 1
        self.getResponseReceivedRequest = request
        
        if let getResponseCompletionReturnValue = getResponseCompletionReturnValue {
            completion(getResponseCompletionReturnValue)
        }
    }
    
    // MARK: - save()
    
    public var saveCallCount = 0
    
    // response parameter
    var saveReceivedResponse: GenresResponseDTO?
    
    func save(response: GenresResponseDTO, for requestDTO: URLRequest) {
        self.saveCallCount += 1
        self.saveReceivedResponse = response
    }
}
