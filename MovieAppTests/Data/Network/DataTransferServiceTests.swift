//
//  DataTransferServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 30/06/2022.
//

import XCTest
@testable import MovieApp


class DataTransferServiceTests: XCTestCase {
    
    private enum ReturnedResult {
        case success
        case failure
    }

    private var networkService: NetworkServiceMock?
    private var sut: DataTransferService?
    
    private var expectedReturnedURLSessionTask: URLSessionTask?
    private var returnedURLSessionTask: URLSessionTask?
    
    private var sentURLRequest: URLRequest?
    private var urlRequestReceivedByNetworkService: URLRequest?
    
    private var returnedResult: ReturnedResult?
    private var returnedGenres: [Genre]?
    private var returnedError: Error?

    private func completion(_ result: DataTransferServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedGenres):
            self.returnedResult = .success
            self.returnedGenres = returnedGenres
        case .failure(let returnedError):
            self.returnedResult = .failure
            self.returnedError = returnedError
        }
    }

    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        self.networkService = nil
        self.sut = nil
        
        self.expectedReturnedURLSessionTask = nil
        self.returnedURLSessionTask = nil
        
        self.sentURLRequest = nil
        self.urlRequestReceivedByNetworkService = nil
        
        self.returnedResult = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_DataTransferService_whenPerformRequest_shouldReturnURLSessionTask() {
        //given
        givenDataTransferServiceInitialised()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureReturnsURLSessionTask()
    }
    
    func test_DataTransferService_whenPerformRequest_shouldCallNetworkServiceExactlyOnce() {
        // given
        givenDataTransferServiceInitialised()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureNetworkServiceCalledExactlyOnce()
    }
    
    func test_DataTransferService_whenPerformRequest_shouldReturnURLSessionTaskFromNetworkService() {
        // given
        givenDataTransferServiceInitialised()
        givenExpectedNetworkRequestResponse()
                
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureReturnsURLSessionTaskFromNetworkService()
    }
    
    func test_DataTransferService_whenPerformRequest_shouldPassRequestToNetworkService() {
        // given
        givenDataTransferServiceInitialised()
                
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestIsPassedToNetworkService()
    }
    
    func test_DataTransferService_whenPerformRequest_shouldReturnResult() {
        // given
        givenDataTransferServiceInitialised()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertNotNil(self.returnedResult)
    }
    
    // MARK: - Given
    
    private func givenDataTransferServiceInitialised() {
        self.networkService = NetworkServiceMock()
        guard let networkService = networkService else { return }
        self.sut = DataTransferService(networkService: networkService)
    }
    
    private func givenExpectedNetworkRequestResponse(of urlSessionTask: URLSessionTask? = nil) {
        self.expectedReturnedURLSessionTask = urlSessionTask ?? URLSessionTask()
        self.networkService?.requestReturnValue = expectedReturnedURLSessionTask
    }
    
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        self.returnedURLSessionTask = sut?.request(request: self.urlRequest()!, completion: self.completion(_:))
    }
    
    // MARK: - Then
    
    private func thenEnsureReturnsURLSessionTask() {
        XCTAssertNotNil(self.returnedURLSessionTask)
    }
    
    private func thenEnsureNetworkServiceCalledExactlyOnce() {
        XCTAssertEqual(self.networkService?.requestCallsCount, 1)
    }
    
    private func thenEnsureReturnsURLSessionTaskFromNetworkService() {
        guard
            let expectedReturnedURLSessionTask = self.expectedReturnedURLSessionTask,
            let returnedURLSessionTask = self.returnedURLSessionTask
        else {
            XCTFail("should not be nil")
            return
        }
        
        XCTAssertEqual(expectedReturnedURLSessionTask, returnedURLSessionTask)
    }
    
    private func thenEnsureRequestIsPassedToNetworkService() {
        XCTAssertEqual(urlRequest(), networkService?.requestReceivedRequest)
    }
    
    // MARK: - Helpers
    
    private func urlRequest() -> URLRequest? {
        URLRequest(url: URL(string: "www.expectedReturnValue.com")!)
    }
    
}
