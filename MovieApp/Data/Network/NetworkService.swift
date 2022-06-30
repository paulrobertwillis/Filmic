//
//  NetworkService.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int)
    case generic(Error)
}

struct NetworkRequest {
    let success: Bool
}

protocol NetworkServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class NetworkService {
    private let networkRequestPerformer: NetworkRequestPerformerProtocol
    
    
    init(networkRequestPerformer: NetworkRequestPerformerProtocol) {
        self.networkRequestPerformer = networkRequestPerformer
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    @discardableResult
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
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
        
        _ = self.networkRequestPerformer.request(request: request) { _, response, error in
            
            if let error = error {
                var errorToBeReturned: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    errorToBeReturned = .error(statusCode: response.statusCode)
                } else {
                    errorToBeReturned = .generic(error)
                }
                
                completion (.failure(errorToBeReturned))
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
    
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask
}

//private class NetworkRequestPerformer: NetworkRequestPerformerProtocol {
//    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
//        return URLSessionTask()
//    }
//}
