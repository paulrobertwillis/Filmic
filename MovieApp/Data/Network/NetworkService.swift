//
//  NetworkService.swift
//  MovieApp
//
//  Created by Paul on 15/06/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func request() -> Result<[Genre], Error>
}

class NetworkService: NetworkServiceProtocol {
    
    func request() -> Result<[Genre], Error> {
//        let url = URL(string: "example.com")!
//        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            // Parse the data in the response and use it
//        }
//        task.resume()
        
        return .success([])
    }
}
