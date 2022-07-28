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
    
    // requestDTO parameter
    var getResponseReceivedRequestDTO: GenresRequestDTO?
    
    // completion parameter
    var getResponseCompletionReturnValue: GenresResponseStorageResultValue?
    
    func getResponse(for requestDTO: GenresRequestDTO, completion: @escaping GenresResponseStorageCompletionHandler) {
        self.getResponseCallCount += 1
        self.getResponseReceivedRequestDTO = requestDTO
        
        if let getResponseCompletionReturnValue = getResponseCompletionReturnValue {
            completion(getResponseCompletionReturnValue)
        }
    }
    
    // MARK: - save()
    
    public var saveCallCount = 0
    
    // responseDTO parameter
    var saveReceivedResponseDTO: GenresResponseDTO?
    
    // requestDTO parameter
    var saveReceivedRequestDTO: GenresRequestDTO?
    
    func save(response: GenresResponseDTO, for request: GenresRequestDTO) {
        self.saveCallCount += 1
        self.saveReceivedResponseDTO = response
        self.saveReceivedRequestDTO = request
    }
}
