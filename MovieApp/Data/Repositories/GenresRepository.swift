//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

class GenresRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension GenresRepository: GenresRepositoryProtocol {
    @discardableResult
    func getMovieGenres(completion: CompletionHandler) -> URLSessionTask? {
        let request = NetworkRequest(success: true)
        let requestResult = self.networkService.request(request, completion: { _ in })
        completion(requestResult)
        return URLSessionTask()
        
//        let request = NetworkRequest(success: true)
//        return self.networkService.request(request, completion: { result in
//            completion(result)
//        })
    }
}
