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
    case someError
}

struct NetworkRequest {
    let success: Bool
}

protocol NetworkServiceProtocol {
    typealias ResultValue = (Result<Data?, NetworkError>)
    typealias CompletionHandler = (ResultValue) -> Void

    @discardableResult
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class NetworkService {
    
    // MARK: - Private Properties
    
    private let networkRequestPerformer: NetworkRequestPerformerProtocol
    
    // MARK: - Lifecycle
    
    init(networkRequestPerformer: NetworkRequestPerformerProtocol) {
        self.networkRequestPerformer = networkRequestPerformer
    }
}

// MARK: - NetworkServiceProtocol

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
        
        _ = self.networkRequestPerformer.request(request: request) { data, response, error in
            
            if let error = error {
                var errorToBeReturned: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    errorToBeReturned = .error(statusCode: response.statusCode)
                } else {
                    errorToBeReturned = .generic(error)
                }
                
                completion (.failure(errorToBeReturned))
            } else {
//                guard let data = data else { return }
//                let genresResponseDTO = try? JSONDecoder().decode(GenresResponseDTO.self, from: data)
//                let genres = genresResponseDTO?.genres.map { $0.toDomain() }
//
//                guard let genres = genres else { return }
                
                completion(.success(data))
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
