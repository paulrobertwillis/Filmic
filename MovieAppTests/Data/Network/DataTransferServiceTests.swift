//
//  DataTransferServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 30/06/2022.
//

import XCTest
@testable import MovieApp


class DataTransferServiceTests: XCTestCase {
    
    
    // MARK: - Setup
    
    
    
    // MARK: - Tests
    
    func test_DataTransferService_whenPerformRequest_shouldReturnOptionalURLSessionTask() {
        //given
        let networkService = NetworkServiceMock()
        let sut = DataTransferService(networkService: networkService)
        
        // when
        let response = sut.request(request: URLRequest(url: URL(string: "www.expectedReturnValue.com")!))
        
        // then
        XCTAssertNotNil(response)
    }
    
    func test_DataTransferService_whenPerformRequest_shouldCallNetworkServiceExactlyOnce() {
        // given
        let networkService = NetworkServiceMock()
        let sut = DataTransferService(networkService: networkService)
        
        // when
        let _ = sut.request(request: URLRequest(url: URL(string: "www.expectedReturnValue.com")!))
        
        // then
        XCTAssertEqual(networkService.requestCallsCount, 1)
    }
    
    func test_DataTransferService_whenPerformRequest_shouldReturnURLSessionTaskFromNetworkService() {
        // given
        let networkService = NetworkServiceMock()
        let expectedReturnValue = URLSessionTask()
        networkService.requestReturnValue = expectedReturnValue
        let sut = DataTransferService(networkService: networkService)
        
        // when
        let actualReturnValue = sut.request(request: URLRequest(url: URL(string: "www.expectedReturnValue.com")!))
        
        // then
        XCTAssertEqual(expectedReturnValue, actualReturnValue)
    }
    
    func test_DataTransferService_whenPerformRequest_shouldPassRequestToNetworkService() {
        // given
        let networkService = NetworkServiceMock()
        let expectedReturnValue = URLRequest(url: URL(string: "www.expectedReturnValue.com")!)
        
        let sut = DataTransferService(networkService: networkService)
        
        // when
        let _ = sut.request(request: expectedReturnValue)
        let actualReturnValue = networkService.requestReceivedRequest
        
        // then
        XCTAssertEqual(expectedReturnValue, actualReturnValue)
    }
    
    // MARK: - Given
}
