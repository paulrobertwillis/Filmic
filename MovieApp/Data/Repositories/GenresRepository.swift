//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

//class Repository<GenericDataTransferService: DataTransferServiceProtocol> {
//    fileprivate let dataTransferService: GenericDataTransferService
//
//    init(dataTransferService: GenericDataTransferService) {
//        self.dataTransferService = dataTransferService
//    }
//}

class GenresRepository: GenresRepositoryProtocol {
    
    fileprivate let dataTransferService: DataTransferService<GenresResponseDTO>
    
    init(dataTransferService: DataTransferService<GenresResponseDTO>) {
        self.dataTransferService = dataTransferService
    }
    
    @discardableResult
    func getMovieGenres(completion: @escaping (Result<[Genre], Error>) -> Void) -> URLSessionTask? {
        let request = URLRequest(url: URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=87c18a6eca3e6995e82fab7f60b9a8a7&language=en-US")!)
        return self.dataTransferService.request(request: request, completion: { (result: Result<GenresResponseDTO, DataTransferError>) in
            
//            result.mapSuccess()
            
            switch result {
            case .success(let response):
                completion(.success(response.genres.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

// one extension on result might be to map success?
// look at map and how to handle failures. Combine's Publishers map will also have lots of things to use

// MARK: - Make extension for mapSuccess() on result value
