//
//  ResponseDecoder.swift
//  MovieApp
//
//  Created by Paul on 01/07/2022.
//

import Foundation

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONResponseDecoder {
    // MARK: - Private Properties
    private let jsonDecoder = JSONDecoder()
}

extension JSONResponseDecoder: ResponseDecoder {
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
