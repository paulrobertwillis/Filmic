//
//  NetworkService.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

enum NetworkError: Error {
    case error
    case expectedError
}

struct NetworkRequest {
    let success: Bool
}

protocol NetworkServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class NetworkService {
    private let networkRequestPerformer: NetworkRequestPerformerProtocol
    
    
    init(networkRequestPerformer: NetworkRequestPerformerProtocol) {
        self.networkRequestPerformer = networkRequestPerformer
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    @discardableResult
    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
//        let url = URL(string: "example.com")!
//        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            // Parse the data in the response and use it
//        }
//        task.resume()
        
//        let dataTaskCompletion: (Data?, URLResponse?, Error?) -> Void = { _,_,_  in }
//        let dataRequest = URLRequest(url: URL(string: "www.example.com")!)
//
//        let task = URLSession.shared.dataTask(with: dataRequest, completionHandler: dataTaskCompletion)
//        task.resume()
//        return task
        
        let sessionDataTest = self.networkRequestPerformer.request(request) { _, _, requestError in
            if let requestError = requestError {
                completion (.failure(requestError))
            } else {
                completion(.success([]))
            }
        }
        
        return URLSessionTask()
    }
}

protocol NetworkRequestPerformerProtocol {
    typealias ResultValue = (Data?, URLResponse?, Error?)
    typealias CompletionHandler = (ResultValue) -> Void
    
    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask
}

//private class NetworkRequestPerformer: NetworkRequestPerformerProtocol {
//    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
//        return URLSessionTask()
//    }
//}
