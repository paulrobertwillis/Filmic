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
    let urlRequest: URLRequest
    var requestName: RequestName
}

struct NetworkResponse {
    let urlResponse: HTTPURLResponse
    var requestName: RequestName
    let data: Data?
    
    init(urlResponse: HTTPURLResponse,
         requestName: RequestName,
         data: Data? = nil) {
        self.urlResponse = urlResponse
        self.requestName = requestName
        self.data = data
    }
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
    private let logger: NetworkLoggerProtocol
    
    // MARK: - Lifecycle
    
    init(networkRequestPerformer: NetworkRequestPerformerProtocol, logger: NetworkLoggerProtocol) {
        self.networkRequestPerformer = networkRequestPerformer
        self.logger = logger
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
            
            if let response = response as? HTTPURLResponse {
                let networkResponse = NetworkResponse(urlResponse: response, requestName: .unknown, data: data)
                self.logger.log(networkResponse)
            }
            
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
        
        let loggableRequest = NetworkRequest(urlRequest: request, requestName: .getMovieGenres)
        self.logger.log(loggableRequest)
        
        return URLSessionTask()
    }
}
