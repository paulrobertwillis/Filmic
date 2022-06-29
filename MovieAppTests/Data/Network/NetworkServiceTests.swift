//
//  NetworkServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest
@testable import MovieApp

class NetworkServiceTests: XCTestCase {
    
    private var sut: NetworkService?
    private var request: NetworkRequest?
    
    private let completion: NetworkServiceProtocol.CompletionHandler = { result in
        
    }
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        self.sut = NetworkService()
    }
    
    override func tearDown() {
        self.sut = nil
        self.request = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_NetworkService_whenInitialised_shouldCreateInstance() {
        // given

        
        // when
        
    
        // then
        XCTAssertNotNil(self.sut)
    }
    
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldReturnSuccessfulResultInCompletionHandler() {
        // given
        let request = NetworkRequest(success: true)
        var requestResponse = "no response"
        
        let successCompletion: NetworkServiceProtocol.CompletionHandler = { result in
            switch result {
            case .success(_):
                requestResponse = "success"
            case .failure(_):
                requestResponse = "failure"
            }
        }
        // when
        self.sut?.request(request, completion: successCompletion)
        
        // then
        XCTAssertEqual(requestResponse, "success")
    }
    
    func test_NetworkService_whenFailsToPerformRequest_shouldReturnFailedResultInCompletionHandler() {
        // given
        let request = NetworkRequest(success: false)
        var requestResponse = "no response"
        
        let successCompletion: NetworkServiceProtocol.CompletionHandler = { result in
            switch result {
            case .success(_):
                requestResponse = "success"
            case .failure(_):
                requestResponse = "failure"
            }
        }
        
        // when
        self.sut?.request(request, completion: successCompletion)
        
        // then
        XCTAssertEqual(requestResponse, "failure")
    }
    
    // should return failure in completion handler
    
    // should return task
        
    // should return request value exactly once
    
    // should return errors
    
    // should return data
    
    // should return http code
    
    // should contain services for logging, error handling, decoding, etc.
    
    // MARK: - Helpers

}
