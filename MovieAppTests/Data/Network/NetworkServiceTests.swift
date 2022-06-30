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
    
    private enum NetworkServiceSuccessTestError: Error {
        case failedRequest
        case expectedError
    }

    private var networkRequestPerformer: NetworkRequestPerformerMock?
    private var sut: NetworkService?
    private var request: NetworkRequest?
    
    private var expectedError: NetworkServiceSuccessTestError?
        
    private var returnedResult: ReturnedResult?
    private var returnedValue: [Genre]?
    private var returnedError: NetworkServiceSuccessTestError?
    
    private func completion(_ result: NetworkServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedValue):
            self.returnedResult = .success
            self.returnedValue = returnedValue
        case .failure(let returnedError):
            self.returnedResult = .failure
            self.returnedError = returnedError as? NetworkServiceSuccessTestError
        }
    }
        
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        
        self.networkRequestPerformer = NetworkRequestPerformerMock()
        self.sut = NetworkService(networkRequestPerformer: networkRequestPerformer!)
    }
    
    override func tearDown() {
        self.networkRequestPerformer = nil
        self.sut = nil
        self.request = nil
        
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
        
//        self.networkRequestPerformer?.request_CompletionParameterReturnValue = (nil, nil, NetworkError.error)
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureFailureResultIsReturnedInCompletionHandler()
    }
    
    func test_NetworkService_whenPerformsRequest_shouldReturnURLSessionTask() {
        // given
        givenRequestWillFail()

        // when
        let task = self.sut?.request(request!, completion: {_ in })
        
        // then
        XCTAssertNotNil(task)
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnAnErrorInFailedResult() {
        // given
        givenRequestWillFail()
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureAnyErrorIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnSpecificNetworkErrorInFailedResult() {
        // given
        self.expectedError = NetworkServiceSuccessTestError.expectedError
        givenRequestWillFail(with: self.expectedError!)
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSpecificNetworkErrorIsReturnedInFailedResult()
    }
        
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnURLResponseInFailedResult() {
        // given
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
    
    private func givenRequestWillSucceed() {
        self.request = NetworkRequest(success: true)
        self.networkRequestPerformer?.request_CompletionParameterReturnValue = (nil, nil, nil)
    }
    
    private func givenRequestWillFail(with error: Error = NetworkServiceSuccessTestError.failedRequest) {
        self.request = NetworkRequest(success: false)
        let url = URL(string: "www.example.com")!
        let urlResponse = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        self.networkRequestPerformer?.request_CompletionParameterReturnValue = (nil, urlResponse, error)
    }
    
    // MARK: - When
    
    private func whenNetworkRequestIsPerformed() {
        guard let request = self.request else { return }

        self.sut?.request(request, completion: self.completion(_:))
    }
    
    // MARK: - Then
    
    private func thenEnsureSuccessfulResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .success)
    }
    
    private func thenEnsureFailureResultIsReturnedInCompletionHandler() {
        XCTAssertEqual(self.returnedResult, .failure)
    }
    
    private func thenEnsureAnyErrorIsReturnedInFailedResult() {
        XCTAssertNotNil(self.returnedError)
    }
    
    private func thenEnsureSpecificNetworkErrorIsReturnedInFailedResult() {
        XCTAssertEqual(self.expectedError, self.returnedError)
    }
    
    private func thenEnsureURLResponseIsReturnedInFailedResult() {
        XCTFail()
    }
    
    // MARK: - Helpers
    
    private func createNetworkRequestMock(willSucceed: Bool) {
        self.request = NetworkRequest(success: willSucceed)
    }
}

private class NetworkRequestPerformerMock: NetworkRequestPerformerProtocol {
    
    var request_ReturnValue: URLSessionTask?
    
    var request_RequestParameterReceivedAsArgument: NetworkRequest? = nil
    
    var request_CompletionParameterReceivedAsArgument: CompletionHandler? = { _ in }
    var request_CompletionParameterReturnValue: ResultValue?

    func request(_ request: NetworkRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        
        self.request_RequestParameterReceivedAsArgument = request
        self.request_CompletionParameterReceivedAsArgument = completion
        
        completion(request_CompletionParameterReturnValue ?? (nil, nil, nil))
        
        
//        completion(request_CompletionParameterReturnValue ?? (nil, nil, nil))
        
        return URLSessionTask()
    }
}
