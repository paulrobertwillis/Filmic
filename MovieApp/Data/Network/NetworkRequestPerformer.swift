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

//private class NetworkRequestPerformer: NetworkRequestPerformerProtocol {
//    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
//        return URLSessionTask()
//    }
//}
