//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

class GenresRepository {
    private let dataTransferService: DataTransferServiceProtocol
    
    init(dataTransferService: DataTransferServiceProtocol) {
        self.dataTransferService = dataTransferService
    }
}

enum GenresError: Error {
    case failedDecode
}

extension GenresRepository: GenresRepositoryProtocol {
    @discardableResult
    func getMovieGenres(completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let request = URLRequest(url: URL(string: "www.example.com")!)
        return self.dataTransferService.request(request: request, completion: { (result: Result<GenresResponseDTO, DataTransferError>) in
            
            switch result {
            case .success(let response):
                completion(.success(response.genres.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
