//
//  DataTransferService.swift
//  MovieApp
//
//  Created by Paul on 30/06/2022.
//

import Foundation

enum DataTransferError: Error {
    case parsingFailure(Error)
}

protocol DataTransferServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class DataTransferService: DataTransferServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
        
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let dataSessionTask = self.networkService.request(request: request) { result in
            switch result {
            case .success(_):
                completion(.success([]))
            case .failure(let error):
                completion(.failure(error))
            }
        }
                
        return dataSessionTask
    }
}
