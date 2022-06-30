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

enum GenresError: Error {
    case failedDecode
}

extension GenresRepository: GenresRepositoryProtocol {
    @discardableResult
    func getMovieGenres(completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let request = URLRequest(url: URL(string: "www.example.com")!)
        return self.networkService.request(request: request, completion: { result in
            
            switch result {
            case .success(let data):
                guard let genres = self.decode(data: data) else {
                    completion(.failure(GenresError.failedDecode))
                    break
                }
                completion(.success(genres))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func decode(data: Data?) -> [Genre]? {
        guard let data = data else { return nil }
        let genresResponseDTO = try? JSONDecoder().decode(GenresResponseDTO.self, from: data)
        let genres = genresResponseDTO?.genres.map { $0.toDomain() }
        
        return genres
    }
}
