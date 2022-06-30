//
//  DataTransferService.swift
//  MovieApp
//
//  Created by Paul on 30/06/2022.
//

import Foundation

protocol DataTransferServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(request: URLRequest, completion: CompletionHandler) -> URLSessionTask?
//    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class DataTransferService: DataTransferServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
//    @discardableResult
//    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
//
//
//        return URLSessionTask()
//    }
    
    func request(request: URLRequest, completion: CompletionHandler) -> URLSessionTask? {
        return self.networkService.request(request: request, completion: { _ in })
    }
}
