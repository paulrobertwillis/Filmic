//
//  NetworkService.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func request() -> [Genre]
}

class NetworkService: NetworkServiceProtocol {
    
    func request() -> [Genre] {
        return []
    }
}
