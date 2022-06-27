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
    func getMovieGenres() -> Result<[Genre], Error> {
        networkService.request()
    }
}
