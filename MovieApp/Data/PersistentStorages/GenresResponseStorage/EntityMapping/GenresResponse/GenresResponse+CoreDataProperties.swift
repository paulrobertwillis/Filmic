//
//  GenresResponse+CoreDataProperties.swift
//  MovieApp
//
//  Created by Paul on 07/08/2022.
//
//

import Foundation
import CoreData


extension GenresResponse {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<GenresResponse> {
        return NSFetchRequest<GenresResponse>(entityName: "GenresResponse")
    }

    @NSManaged public var genres: NSSet?
    @NSManaged public var request: GenresRequest?

}

// MARK: Generated accessors for genres
extension GenresResponse {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: GenreResponse)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: GenreResponse)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

extension GenresResponse : Identifiable {

}
