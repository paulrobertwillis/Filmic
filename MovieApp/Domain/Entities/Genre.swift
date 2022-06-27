//
//  Genre.swift
//  MovieApp
//
//  Created by Paul on 27/06/2022.
//

import Foundation

struct Genre: Equatable, Identifiable {
    typealias Identifier = String
    
    let id: Identifier
    let name: String?
}
