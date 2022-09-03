//
//  GenreResponseDTO.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

struct GenreResponseDTO: Decodable, Equatable {
    let id: Int
    let name: String
}

extension GenreResponseDTO {
    func toDomain() -> Genre {
        return .init(
            id: Genre.Identifier(id),
            name: self.name
        )
    }
}
