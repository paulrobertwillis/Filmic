//
//  NetworkRequestPerformer.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

protocol NetworkRequestPerformerProtocol {
    typealias ResultValue = (Data?, URLResponse?, Error?)
    typealias CompletionHandler = (ResultValue) -> Void
    
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask
}

class NetworkRequestPerformer: NetworkRequestPerformerProtocol {
    // TODO: Replace URLRequest here with NetworkRequest?
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        return URLSessionTask()
    }
    
    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        return URLSessionTask()
    }
}
