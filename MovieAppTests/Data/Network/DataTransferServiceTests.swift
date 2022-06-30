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
    
    private enum DataTransferErrorMock: Error {
        case someError
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
        self.returnedGenres = nil
        self.returnedError = nil
        
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
    
    func test_DataTransferService_whenPerformSuccessfulRequest_shouldReturnSuccessResultInCompletionHandler() {
        // given
        givenDataTransferServiceInitialised()
        self.networkService?.requestCompletionReturnValue = .success(nil)
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertEqual(self.returnedResult, .success)
    }
    
    func test_DataTransferService_whenPerformFailedRequest_shouldReturnFailureResultInCompletionHandler() {
        // given
        givenDataTransferServiceInitialised()
        self.networkService?.requestCompletionReturnValue = .failure(DataTransferErrorMock.someError)
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertEqual(self.returnedResult, .failure)
    }
    
    func test_DataTransferService_whenPerformSuccessfulRequest_shouldReturnGenres() {
        // given
        givenDataTransferServiceInitialised()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertEqual(self.returnedGenres, [])
    }
    
    func test_DataTransferService_whenPerformSuccessfulRequest_shouldReturnURLSessionTask() {
        // given
        givenDataTransferServiceInitialised()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertNotNil(self.returnedURLSessionTask)
    }
    
    func test_DataTransferService_whenPerformFailedRequest_shouldReturnErrorInFailureResult() {
        // given
        givenDataTransferServiceInitialised()
        self.networkService?.requestCompletionReturnValue = .failure(DataTransferErrorMock.someError)
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        XCTAssertNotNil(self.returnedError)
    }
    
    func test_DataTransferService_whenPerformFailedRequest_shouldReturnSpecificDataTransferErrorInFailureResult() {
        // given
        givenDataTransferServiceInitialised()
        let expectedError = DataTransferErrorMock.someError
        self.networkService?.requestCompletionReturnValue = .failure(expectedError)
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        guard let returnedError = self.returnedError else {
            XCTFail("Should always be non-nil value at this point")
            return
        }

        if case DataTransferErrorMock.someError = returnedError {
            XCTAssertEqual(expectedError, returnedError as? DataTransferServiceTests.DataTransferErrorMock)
        }
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

// TODO: Tests

// Add completion handler

// should return success/failure to completion handler

// should take data from NetworkService and decode it

// decoding should belong to a separate object, a DataUnwrapperService

// DataUnwrapperService should have its own tests

// DataTransferService should keep logs of failures to unwrap

// DataTransferService should have a logger

// DataTransferLogger should have its own tests

// GenreRepository should instead go to DataTransferService for [Genre]

// Networking should become more generic to handle decoding of greater range of objects

// Generic network should be extensively tested to ensure it can decode objects of all types implemented in the Domain layer
