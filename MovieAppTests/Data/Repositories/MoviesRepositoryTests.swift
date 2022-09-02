//
//  MoviesRepositoryTests.swift
//  MovieAppTests
//
//  Created by Paul on 03/09/2022.
//

import XCTest
@testable import MovieApp

class MoviesRepositoryTests: XCTestCase {

    // MARK: - Private Properties
    
    private var sut: MoviesRepository!
        
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.sut = MoviesRepository()
    }
    
    override func tearDown() {
        self.sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_Mapping_whenPerformsSuccessfulRequestToDataTransferService_shouldMapDTOToDomainObject() {
        // given
        
        // when
        
        
        // then
        
    }
}

