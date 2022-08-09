//
//  GenresRequest+CoreDataProperties.swift
//  MovieApp
//
//  Created by Paul on 07/08/2022.
//
//

import Foundation
import CoreData


extension GenresRequest {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<GenresRequest> {
        return NSFetchRequest<GenresRequest>(entityName: "GenresRequest")
    }

    @NSManaged public var type: String?
    @NSManaged public var genresResponse: GenresResponse?

}

extension GenresRequest : Identifiable {

}
