//
//  DataTransferService.swift
//  MovieApp
//
//  Created by Paul on 30/06/2022.
//

import Foundation

enum DataTransferError: Error {
    case parsingFailure(Error)
    case missingData
    case decodingFailure
}

protocol DataTransferServiceProtocol {
    typealias ResultValue = (Result<[Genre], Error>)
    typealias CompletionHandler = (ResultValue) -> Void

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class DataTransferService: DataTransferServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
        
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let dataSessionTask = self.networkService.request(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let returnValue = try self.decode(data: data)
                    completion(.success(returnValue))
                } catch(let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
                
        return dataSessionTask
    }
    
    private func decode(data: Data?) throws -> [Genre] {
        guard let data = data else { throw DataTransferError.missingData }
        let genresResponseDTO = try? JSONDecoder().decode(GenresResponseDTO.self, from: data)
        let genres = genresResponseDTO?.genres.map { $0.toDomain() }
        
        guard let genres = genres else { throw DataTransferError.decodingFailure }
        
        return genres
    }
}
