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
    
    public var mostRecentLog: String?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
        
    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask? {
        
        let dataSessionTask = self.networkService.request(request: request) { result in
            switch result {
            case .success(let data):
                self.handleSuccessfulRequest(for: data, completion: completion)
            case .failure(let error):
                self.resolveAndHandleError(error, completion: completion)
            }
        }
                
        return dataSessionTask
    }
    
    // TODO: Consider how to migrate this decode function to the more appropriate ResponseDecoder object
    private func decode<T: Decodable>(_ data: Data?) throws -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.missingData) }
            let result: T = try self.decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsingFailure(error))
        }
    }
    
    private func resolve(_ error: Error) -> DataTransferError {
        return DataTransferError.parsingFailure(error)
    }
    
    private func handleSuccessfulRequest(for data: Data?, completion: CompletionHandler) {
        do {
            try self.decodeAndHandleResult(from: data, completion: completion)
        } catch(let error) {
            self.resolveAndHandleError(error, completion: completion)
        }
    }
    
    // TODO: Consider how to refactor this function to do only one thing
    private func decodeAndHandleResult(from data: Data?, completion: CompletionHandler) throws {
        let result: ResultValue = try self.decode(data)
        completion(result)
    }
    
    // TODO: Consider how to refactor this function to do only one thing
    private func resolveAndHandleError(_ error: Error, completion: CompletionHandler) {
        let resolvedError = self.resolve(error)
        completion(.failure(resolvedError))
    }
}
