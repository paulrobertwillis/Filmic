//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

class GenresRepository: GenresRepositoryProtocol {
    
    private let dataTransferService: DataTransferService<GenresResponseDTO>
    private let cache: GenresResponseStorageProtocol
    
    init(dataTransferService: DataTransferService<GenresResponseDTO>, cache: GenresResponseStorageProtocol) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    
    @discardableResult
    func getMovieGenres(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        let requestDTO = GenresRequestDTO(type: .movie)
        
        self.cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO) = result {
                completion(.success(responseDTO.genres.map { $0.toDomain() }))
            } else {
                self.dataTransferService.request(request) { (result: Result<GenresResponseDTO, DataTransferError>) in
                    
                    // result.mapSuccess()
                    
                    switch result {
                    case .success(let responseDTO):
                        completion(.success(responseDTO.genres.map { $0.toDomain() }))
                        self.cache.save(response: responseDTO, for: requestDTO)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        
        return URLSessionTask()
    }
}

// one extension on result might be to map success?
// look at map and how to handle failures. Combine's Publishers map will also have lots of things to use

// MARK: - Make extension for mapSuccess() on result value

