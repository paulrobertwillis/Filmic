//
//  PaginatedResponseDTO.swift
//  MovieApp
//
//  Created by Paul on 03/09/2022.
//

import Foundation

public protocol PaginatedResponseDTO: Decodable, Equatable {
    associatedtype T: Decodable where T: Equatable
    
    var page: Int { get }
    var results: [T] { get }
    var totalResults: Int { get }
    var totalPages: Int { get }
}
