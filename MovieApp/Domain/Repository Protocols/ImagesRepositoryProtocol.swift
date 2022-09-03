//
//  ImagesRepositoryProtocol.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

protocol ImagesRepositoryProtocol {
    typealias ResultValue = (Result<Data, Error>)
    typealias CompletionHandler = (ResultValue) -> Void
    
    @discardableResult
    func getImage(request: URLRequest, decoder: ResponseDecoderProtocol, completion: @escaping CompletionHandler) -> URLSessionTask?
}
