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
    associatedtype GenericDecodable: Decodable
    
    typealias ResultValue = (Result<GenericDecodable, DataTransferError>)
    typealias CompletionHandler = (ResultValue) -> Void

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask?
}

class DataTransferService<GenericDecodable: Decodable>: DataTransferServiceProtocol {
    
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
                    let result: ResultValue = try self.decode(data)
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
    
    private func decode<T: Decodable>(_ data: Data?) throws -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.missingData) }
            let result: T = try self.decoder.decode(data)
            return .success(result)
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
