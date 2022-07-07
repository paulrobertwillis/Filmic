//
//  NetworkServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest
@testable import MovieApp

enum NetworkErrorMock: Error {
    case someError
}

class NetworkServiceTests: XCTestCase {
    
    private enum ReturnedResult {
        case success
        case failure
    }
        
    private var networkRequestPerformer: NetworkRequestPerformerMock?
    private var logger: NetworkLoggerMock = NetworkLoggerMock()

    private var sut: NetworkService?
    
    private var request: URLRequest?
    private var task: URLSessionTask?
    
    private var expectedError: NetworkErrorMock?
    
    private var returnedResult: ReturnedResult?
    private var returnedValue: [Genre]?
    private var returnedData: Data?
    private var returnedError: Error?
    
    private func completion(_ result: NetworkServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedData):
            self.returnedResult = .success
            self.returnedData = returnedData
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
        self.networkRequestPerformer = nil
//        self.logger = nil
        
        self.sut = nil
        
        self.request = nil
        self.task = nil
        
        self.expectedError = nil
        
        self.returnedResult = nil
        self.returnedValue = nil
        self.returnedError = nil
        
        super.tearDown()
    }

    // MARK: - Tests
    
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldReturnSuccessfulResultInCompletionHandler() {
        // given
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSuccessfulResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
                
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureFailureResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsRequest_shouldReturnURLSessionTask() {
        // given
        givenRequestWillFail()

        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureTaskIsReturned()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnAnErrorInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureAnyErrorIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnSpecificNetworkErrorInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSpecificNetworkErrorIsReturnedInFailedResult()
    }
        
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnURLResponseInFailedResultInCompletionHandler() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureURLResponseIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldCallRequestPerformerExactlyOnce() {
        // given
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 1)
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldCallRequestPerformerExactlyOnce() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 1)
    }
    
    func test_NetworkService_whenPerformsMultipleRequests_shouldCallRequestPerformerTheSameNumberOfTimes() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 2)
    }
    
    func test_NetworkService_whenPerformsChainOfFailingAndSucceedingRequests_shouldCallRequestPerformerTheSameNumberOfTimes() {
        // given
        createRequestStub()
        
        // when
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()

        // then
        thenEnsureRequestPerformerCalled(numberOfTimes: 5)
    }
    
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldReturnDataInCompletionHandler() {
        // given
        createRequestStub()
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
//        thenEnsureDataIsReturnedInCompletionHandler()
        XCTAssertNotNil(self.returnedData)
    }
    
    
    
    // URLResponse should match expectations:
    /*
     200: Success
     401: Unauthorised
     404: Resource not found
     */
        
    // should include data in error code
    
    // data in an error should be logged to console for now
    
    // should contain services for logging, error handling, decoding, etc.
    
    // data in an error should eventually be saved to file somewhere
    
    // NeworkService should have NetworkConfiguration that contains base URL, etc.
    
    
    
    
    func test_Logging_whenPerformsSuccessfulRequest_shouldLogResponseToConsole() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        XCTAssertEqual(1, self.logger.logResponseCallCount)
    }
    
    func test_Logging_whenPerformsFailedRequest_shouldLogResponseToConsole() {
        // when
        whenFailedNetworkRequestIsPerformed()
        
        // then
        XCTAssertEqual(1, self.logger.logResponseCallCount)
    }
    
    func test_Logging_whenPerformsMultipleSuccessfulRequests_shouldLogResponseToConsoleMultipleTimes() {
        // when
        whenSuccessfulNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        XCTAssertEqual(2, self.logger.logResponseCallCount)
    }
    
    func test_Logging_whenPerformsMultipleFailedRequests_shouldLogResponseToConsoleMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()

        // then
        XCTAssertEqual(2, self.logger.logResponseCallCount)
    }

    func test_Logging_whenPerformsMultipleSuccessfulAndFailedRequests_shouldLogResponseToConsoleMultipleTimes() {
        // when
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()
        whenFailedNetworkRequestIsPerformed()
        whenSuccessfulNetworkRequestIsPerformed()

        // then
        XCTAssertEqual(4, self.logger.logResponseCallCount)
    }

    
    // TODO: Network Logger
    // successful request should log time request made
    
    // successful request should log request type
    
    // successful request should log method type (.get, .post etc.)
    
    // successful request should log headers
    
    // successful request should log body
    
    
    // successful response should log time received

    // successful response should log request type
    
    // successful response should log url response received from
    
    // successful response should log status and whether success
    
    // successful response should log whether data was successfully parsed
    
    // successful response should log headers
    
    // successful response should log body
    
    // unsuccessful response should log as above, plus a description of status code e.g. 404 Resource not found
    
    
    
    
    // MARK: - Given
        
    private func givenRequestWillSucceed() {
        createRequestStub()
        initialiseNetworkRequestPerformer(data: TMDBResponseMocks.Genres.getGenres.successResponse(), response: createSuccessResponseStub(), error: nil)
        initialiseNetworkService()
    }
    
    private func givenRequestWillFail() {
        createRequestStub()
        self.expectedError = NetworkErrorMock.someError
        initialiseNetworkRequestPerformer(data: nil, response: createFailureResponseStub(), error: NetworkErrorMock.someError)
        initialiseNetworkService()
    }
        
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        self.task = self.sut?.request(request: self.request!, completion: self.completion(_:))
    }
    
    private func whenSuccessfulNetworkRequestIsPerformed() {
        givenRequestWillSucceed()
        whenNetworkRequestIsPerformed()
    }
    
    private func whenFailedNetworkRequestIsPerformed() {
        givenRequestWillFail()
        whenNetworkRequestIsPerformed()
    }
    
    // MARK: - Then
    
    private func thenEnsureSuccessfulResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .success)
    }
    
    private func thenEnsureFailureResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .failure)
    }
    
    private func thenEnsureTaskIsReturned() {
        XCTAssertNotNil(self.task)
    }
    
    private func thenEnsureAnyErrorIsReturnedInFailedResult() {
        XCTAssertNotNil(self.returnedError)
    }
    
    private func thenEnsureSpecificNetworkErrorIsReturnedInFailedResult() {
        guard let returnedError = returnedError else {
            XCTFail("Should always be non-nil value at this point")
            return
        }

        if case NetworkError.error(let statusCode) = returnedError {
            XCTAssertEqual(statusCode, self.createFailureResponseStub()?.statusCode)
        }
    }
    
    private func thenEnsureURLResponseIsReturnedInFailedResult() {
        guard let returnedError = returnedError else {
            XCTFail("Should always be non-nil value at this point")
            return
        }
        
        if case NetworkError.error(let statusCode) = returnedError {
            XCTAssertNotNil(statusCode)
        }
    }
        
    private func thenEnsureRequestPerformerCalled(numberOfTimes expectedCalls: Int) {
        let actualCalls = self.networkRequestPerformer?.requestCallsCount
        XCTAssertEqual(expectedCalls, actualCalls)
    }
    
    // MARK: - Helpers
    
    private func initialiseNetworkService() {
        self.sut = NetworkService(networkRequestPerformer: self.networkRequestPerformer!,
                                  logger: self.logger)
    }
    
    private func initialiseNetworkRequestPerformer(data: Data?, response: HTTPURLResponse?, error: Error?) {
        if self.networkRequestPerformer != nil { return }
        
        self.networkRequestPerformer = NetworkRequestPerformerMock(data: data,
                                                                   response: response,
                                                                   error: error)
    }
    
    private func createRequestStub() {
        self.request = URLRequest(url: URL(string: "www.test.com")!)
    }

    private func createSuccessResponseStub() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
    
    private func createFailureResponseStub() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
}

