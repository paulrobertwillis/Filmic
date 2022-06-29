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

    private var networkRequestPerformer: NetworkRequestPerformerMock?
    private var sut: NetworkService?
    private var request: NetworkRequest?
    
    private var expectedError: NetworkError?
        
    private var returnedResult: ReturnedResult?
    private var returnedValue: [Genre]?
    private var returnedError: NetworkError?
    
    private func completion(_ result: NetworkServiceProtocol.ResultValue) {
        switch result {
        case .success(let returnedValue):
            self.returnedResult = .success
            self.returnedValue = returnedValue
        case .failure(let returnedError):
            self.returnedResult = .failure
            self.returnedError = returnedError as? NetworkError
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
        thenEnsureAnErrorIsReturnedInFailedResult()
    }
    
    func test_NetworkService_whenPerformsFailedRequest_shouldReturnSpecificNetworkErrorInFailedResult() {
        // given
        self.expectedError = NetworkError.expectedError
        givenRequestWillFail(with: self.expectedError!)
        
        // when
        whenNetworkRequestIsPerformed()

        // then
        thenEnsureSpecificNetworkErrorIsReturnedInFailedResult()
    }
        
    func test_NetworkService_whenPerformsSuccessfulRequest_shouldReturnURLResponseInSuccessfulResult() {
        // given
        givenRequestWillSucceed()
        
        // when
        whenNetworkRequestIsPerformed()
        
        // then
        thenEnsureURLResponseIsReturnedInSuccessfulResult()
    }
    
    // should return data
    
    // should return http code
    
    // should contain services for logging, error handling, decoding, etc.
    
    
    // MARK: - Given
    
    private func givenRequestWillSucceed() {
        self.request = NetworkRequest(success: true)
        self.networkRequestPerformer?.request_CompletionParameterReturnValue = (nil, nil, nil)
    }
    
    private func givenRequestWillFail(with error: Error = NetworkError.error) {
        self.request = NetworkRequest(success: false)
        self.networkRequestPerformer?.request_CompletionParameterReturnValue = (nil, nil, error)
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
    
    private func thenEnsureAnErrorIsReturnedInFailedResult() {
        XCTAssertNotNil(self.returnedError)
    }
    
    private func thenEnsureSpecificNetworkErrorIsReturnedInFailedResult() {
        XCTAssertEqual(self.expectedError, self.returnedError)
    }
    
    private func thenEnsureURLResponseIsReturnedInSuccessfulResult() {
        XCTFail()
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
