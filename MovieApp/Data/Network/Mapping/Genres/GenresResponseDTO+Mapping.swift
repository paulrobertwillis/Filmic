//
//  GenresResponseDTO+Mapping.swift
//  MovieApp
//
//  Created by Paul on 30/06/2022.
//

import Foundation

// TODO: Remove public access
public struct GenresResponseDTO: Decodable, Equatable {
    let genres: [GenreDTO]
}

extension GenresResponseDTO {
    struct GenreDTO: Decodable, Equatable {
        let id: Int
        let name: String
    }
}

extension GenresResponseDTO.GenreDTO {
    func toDomain() -> Genre {
        return .init(
            id: Genre.Identifier(id),
            name: self.name
        )
    }
}
