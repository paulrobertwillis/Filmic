//
//  GenresResponse+Mapping.swift
//  MovieApp
//
//  Created by Paul on 07/08/2022.
//

import Foundation
import CoreData

extension GenresResponse {
    func toDTO() -> GenresResponseDTO {
        .init(genres: self.genres?.allObjects.map { ($0 as! GenreResponse).toDTO() } ?? [])
    }
}

extension GenreResponse {
    func toDTO() -> GenresResponseDTO.GenreDTO {
        .init(id: Int(self.id),
              name: self.name ?? "")
    }
}

extension GenresRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> GenresRequest {
        let entity: GenresRequest = .init(context: context)
        entity.type = self.type.rawValue
        return entity
    }
}

extension GenresResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> GenresResponse {
        let entity: GenresResponse = .init(context: context)
        self.genres.forEach {
            entity.addToGenres($0.toEntity(in: context))
        }
        return entity
    }
}

extension GenresResponseDTO.GenreDTO {
    func toEntity(in context: NSManagedObjectContext) -> GenreResponse {
        let entity: GenreResponse = .init(context: context)
        entity.id = Int32(self.id)
        entity.name = self.name
        return entity
    }
}
