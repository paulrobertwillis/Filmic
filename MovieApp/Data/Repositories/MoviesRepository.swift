//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

class MoviesRepository: MoviesRepositoryProtocol {
        
    // MARK: - Private Properties
    
    private let dataTransferService: DataTransferService<MoviesResponseDTO>
    
    // MARK: - Init
    
    init(dataTransferService: DataTransferService<MoviesResponseDTO>) {
        self.dataTransferService = dataTransferService
    }
    
    // MARK: - API
    
    @discardableResult
    func getMovies(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        self.dataTransferService.request(request, decoder: JSONResponseDecoder()) { (result: Result<MoviesResponseDTO, DataTransferError>) in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
