//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

class Repository<GenericDataTransferService: DataTransferServiceProtocol> {
    private let dataTransferService: GenericDataTransferService
    
    init(dataTransferService: GenericDataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension Repository where GenericDataTransferService.GenericDecodable == GenresResponseDTO {
    @discardableResult
    func getMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) -> URLSessionTask? {
        
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
