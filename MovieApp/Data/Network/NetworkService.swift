//
//  NetworkService.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

enum NetworkError: Error {
    case error
}

struct NetworkRequest {
    let success: Bool
}

protocol NetworkServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(_ request: NetworkRequest, completion: CompletionHandler) -> URLSessionTask?
}

class NetworkService: NetworkServiceProtocol {
    
    @discardableResult
    func request(_ request: NetworkRequest, completion: CompletionHandler) -> URLSessionTask? {
//        let url = URL(string: "example.com")!
//        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            // Parse the data in the response and use it
//        }
//        task.resume()
        if request.success {
            completion(.success([]))
        } else {
            completion(.failure(NetworkError.error))
        }
        
        return URLSessionTask()
    }
}
