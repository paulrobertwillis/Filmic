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
    func getMovieGenres(completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let request = URLRequest(url: URL(string: "www.example.com")!)
        return self.networkService.request(request: request, completion: { result in
            completion(result)
        })
    }
}
