//
//  GenresRepository.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

class GenresRepository: GenresRepositoryProtocol {
    
    // MARK: - Private Properties
    
    private let dataTransferService: DataTransferService<GenresResponseDTO>
    private let cache: GenresResponseStorageProtocol
    
    // MARK: - Init
    
    init(dataTransferService: DataTransferService<GenresResponseDTO>, cache: GenresResponseStorageProtocol) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
    
    // MARK: - API
    
    @discardableResult
    func getMovieGenres(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        let requestDTO = GenresRequestDTO(type: .movie)
        
        // TODO: Find way to handle success/failure results nicely with extension on Result
//        self.cache.getResponse(for: requestDTO) { result in
//            result.handle(
//                success: self.handleGenresRetrievalSuccessFromCache,
//                failure: self.handleGenresRetrievalFailureFromCache
//            )
//        }
        
        self.cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO) = result {
                completion(.success(responseDTO.genres.map { $0.toDomain() }))
            } else {
                self.dataTransferService.request(request) { (result: Result<GenresResponseDTO, DataTransferError>) in
                    
                    // result.mapSuccess()
                    
                    switch result {
                    case .success(let responseDTO):
                        completion(.success(responseDTO.genres.map { $0.toDomain() }))
                        self.cache.save(responseDTO: responseDTO, for: requestDTO)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
        
        return URLSessionTask()
    }
    
//    private func handleGenresRetrievalSuccessFromCache(genresResponseDTO: GenresResponseDTO) {
//        completion(.success(genresResponseDTO.genres.map { $0.toDomain() }))
//    }
//
//    private func handleGenresRetrievalFailureFromCache(error: CoreDataStorageError) {
//        self.dataTransferService.request(request) { (result: Result<GenresResponseDTO, DataTransferError>) in
//
//            result.handle(
//                success: self.handleGenresRetrievalSuccessFromDataTransferService,
//                failure: self.handleGenresRetrievalFailureFromDataTransferService
//            )
//        }
//    }
//
//    private func handleGenresRetrievalSuccessFromDataTransferService(genresResponseDTO: GenresResponseDTO) {
//        completion(.success(responseDTO.genres.map { $0.toDomain() }))
//        self.cache.save(responseDTO: responseDTO, for: requestDTO)
//    }
//
//    private func handleGenresRetrievalFailureFromDataTransferService(error: DataTransferError) {
//        completion(.failure(error))
//    }
    
}

// one extension on result might be to map success?
// look at map and how to handle failures. Combine's Publishers map will also have lots of things to use

// MARK: - Make extension for mapSuccess() on result value

extension Result {
    func handle(success: (Success) -> Void, failure: (Failure) -> Void) {
        switch self {
        case .success(let s): success(s)
        case .failure(let f): failure(f)
        }
    }
}





//public protocol FetchEmployerDetailsUseCase {
//  func execute(_ completion: @escaping (Result<EmployerDetails, Error>) -> Void)
//}


//self.fetchEmployerDetailsUseCase.execute {
//    $0.handle(success: self.handleEmployerDetailsRetrieveSuccess,
//              failure: self.handleEmployerDetailsRetrieveError)
//}

//private func handleEmployerDetailsRetrieveSuccess(details: EmployerDetails) {
//    self.employerDetails = details
//
//    self.employmentDetails.configure(for: .employerName, with: details.name)
//    self.employmentDetails.configure(for: .employerAddress, with: details.address)
//    self.employmentDetails.configure(for: .employerPhone, with: details.phoneNumber)
//
//    self.occupationDelegate?.displayEmployerDetails(details: details)
//}

//private func handleEmployerDetailsRetrieveError(error: Error) {
//    self.employerDetails = nil
//    self.occupationDelegate?.displayEmployerDetailsError()
//}
