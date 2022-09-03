//
//  ImagesRepository.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

class ImagesRepository {
    private let dataTransferService: DataTransferService<Data>
    
    init(dataTransferService: DataTransferService<Data>) {
        self.dataTransferService = dataTransferService
    }
}

extension ImagesRepository: ImagesRepositoryProtocol {
    @discardableResult
    func getImage(request: URLRequest, decoder: ResponseDecoderProtocol, completion: @escaping CompletionHandler) -> URLSessionTask? {
        let decoder = RawDataResponseDecoder()
        
        return self.dataTransferService.request(request, decoder: decoder) { (result: Result<Data, DataTransferError>) in
            
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
    }
}
