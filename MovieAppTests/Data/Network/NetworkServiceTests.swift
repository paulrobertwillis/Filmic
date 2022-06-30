//
//  NetworkServiceTests.swift
//  MovieAppTests
//
//  Created by Paul on 15/06/2022.
//

import XCTest
@testable import MovieApp

class NetworkServiceTests: XCTestCase {
    
    private enum ReturnedResult {
        case success
        case failure
    }
        
    private enum NetworkErrorMock: Error {
        case someError
    }

    private var networkRequestPerformer: NetworkRequestPerformerMock?
    private var sut: NetworkService?
    private var request: URLRequest?
    private var task: URLSessionTask?
    
    private var expectedError: NetworkErrorMock?
    
    private var returnedResult: ReturnedResult?
    private var returnedValue: [Genre]?
    private var returnedError: Error?
    
    private func completion(_ result: NetworkServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedValue):
            self.returnedResult = .success
            self.returnedValue = returnedValue
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
        givenRequestIsReceived()
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSuccessfulResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnFailedResultInCompletionHandler() {
        // given
        givenRequestIsReceived()
        givenRequestWillFail()
                
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureFailureResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsRequest_shouldReturnURLSessionTask() {
        // given
        givenRequestIsReceived()
        givenRequestWillFail()

        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureTaskIsReturned()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnAnErrorInFailedResult() {
        // given
        givenRequestIsReceived()
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureAnyErrorIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnSpecificNetworkErrorInFailedResult() {
        // given
        givenRequestIsReceived()
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSpecificNetworkErrorIsReturnedInFailedResult()
    }
        
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnURLResponseInFailedResult() {
        // given
        givenRequestIsReceived()
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureURLResponseIsReturnedInFailedResult()
    }
    
    // should return data
    
    // should return http code
    
    // should contain services for logging, error handling, decoding, etc.
    
    
    // MARK: - Given
    
    private func givenRequestIsReceived() {
        self.request = URLRequest(url: URL(string: "www.test.com")!)
    }
    
    private func givenRequestWillSucceed() {
        self.networkRequestPerformer = NetworkRequestPerformerMock(data: nil,
                                                                   response: successResponse(),
                                                                   error: nil)
        createNetworkService()
    }
    
    private func givenRequestWillFail() {
        self.expectedError = NetworkErrorMock.someError
        self.networkRequestPerformer = NetworkRequestPerformerMock(data: nil,
                                                                   response: failureResponse(),
                                                                   error: NetworkErrorMock.someError)
        createNetworkService()
    }
    
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        self.task = self.sut?.request(request: self.request!, completion: self.completion(_:))
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
            XCTAssertEqual(statusCode, self.failureResponse()?.statusCode)
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
    
    // MARK: - Helpers
    
    private func createNetworkService() {
        self.sut = NetworkService(networkRequestPerformer: self.networkRequestPerformer!)
    }
        
    private func successResponse() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
    
    private func failureResponse() -> HTTPURLResponse? {
        HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
    }
}

private struct NetworkRequestPerformerMock: NetworkRequestPerformerProtocol {
    
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?

    func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        
        completion((data, response, error))
        return URLSessionDataTask()
    }
}
