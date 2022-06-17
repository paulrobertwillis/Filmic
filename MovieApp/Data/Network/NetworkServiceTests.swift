//
//  NetworkServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest
@testable import MovieApp

class NetworkServiceTests: XCTestCase {

    func testNetworkService_whenInitialised_shouldCreateInstance() {
        let networkService = NetworkService()
        
        XCTAssertNotNil(networkService)
    }
    
}
