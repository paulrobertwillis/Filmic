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
    typealias ResultValue = (Result<[Genre], DataTransferError>)
    typealias CompletionHandler = (ResultValue) -> Void

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class DataTransferService: DataTransferServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let decoder: ResponseDecoder = JSONResponseDecoder()
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
        
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let dataSessionTask = self.networkService.request(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decode(data)
                    completion(result)
                } catch(let error) {
                    let resolvedError = self.resolve(error)
                    completion(.failure(resolvedError))
                }
            case .failure(let error):
                let resolvedError = self.resolve(error)
                completion(.failure(resolvedError))
            }
        }
                
        return dataSessionTask
    }
    
    private func decode(_ data: Data?) throws -> Result<[Genre], DataTransferError> {
        do {
            guard let data = data else { return .failure(.missingData) }
            let result: GenresResponseDTO = try self.decoder.decode(data)
            
            let genres = result.genres.map { $0.toDomain() }

            
            return .success(genres)
        } catch {
            return .failure(.parsingFailure(error))
        }
//        guard let data = data else { throw DataTransferError.missingData }
//        let genresResponseDTO = try? JSONDecoder().decode(GenresResponseDTO.self, from: data)
//        let genres = genresResponseDTO?.genres.map { $0.toDomain() }
//
//        guard let genres = genres else { throw DataTransferError.decodingFailure }
//
//        return genres
    }
    
    private func resolve(_ error: Error) -> DataTransferError {
        return DataTransferError.parsingFailure(error)
    }
}

public protocol ResponseDecoder {
    func decode(_ data: Data) throws -> GenresResponseDTO
}

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    
    public func decode(_ data: Data) throws -> GenresResponseDTO {
        return try jsonDecoder.decode(GenresResponseDTO.self, from: data)
    }
}
