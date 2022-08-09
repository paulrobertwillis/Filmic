//
//  GenreResponse+CoreDataProperties.swift
//  MovieApp
//
//  Created by Paul on 07/08/2022.
//
//

import Foundation
import CoreData


extension GenreResponse {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<GenreResponse> {
        return NSFetchRequest<GenreResponse>(entityName: "GenreResponse")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var genresResponse: GenresResponse?

}

extension GenreResponse : Identifiable {

}
