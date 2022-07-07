//
//  NetworkLoggerTests.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class NetworkLoggerTests: XCTestCase {

    // MARK: - Private Properties
    
    private var sut: NetworkLogger?
    
    private var url: URL?
    
    private var requestType: RequestName?
    private var request: NetworkRequest?
    private var response: NetworkResponse?
    
    private var networkError: NetworkErrorMock?
    
    private enum NetworkLoggerRequestNameMock: RequestNameProtocol {
        case someRequestName
    }
    
    // MARK: - Setup
    
    override func setUp() {
        self.sut = NetworkLogger()
        
        self.url = URL(string: "www.example.com")
    }
    
    override func tearDown() {
        self.sut = nil
        
        self.url = nil
        
        self.requestType = nil
        self.request = nil
        self.response = nil
        
        self.networkError = nil
    }
    
    // MARK: - Tests
    
    func test_NetworkLogger_whenLoggingResponseStatus_shouldCreateLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogsCreated(count: 1)
    }
    
    func test_NetworkLogger_whenLoggingMultipleResponseStatuses_shouldCreateMultipleLogs() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        whenResponseIsLogged()

        // then
        thenEnsureLogsCreated(count: 2)
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainSuccessStatusCode() {
        // given
        givenSuccessfulResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogStatusCode(is: 200)
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldNotContainSuccessfulStatusCode() {
        // given
        givenFailedResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogStatusCodeIsNotSuccess()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsSuccessfulStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenFailedResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsFailedStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainEmptyHTTPResponseStatusCodeDescriptionIfResponseStatusCodeNotRecognised() {
        // given
        givenFailedResponseWithUnrecognisedStatusCode()
        
        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsEmptyStringAsStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldBeResponseLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldBeResponseLog() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }

    func test_NetworkLogger_whenLoggingRequest_LogShouldBeRequestLog() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogTypeIsRequest()
    }
    
    func test_NetworkLogger_whenLoggingRequest_LogShouldContainRequestURL() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogTypeIsRequest()
    }
    
    func test_NetworkLogger_whenLoggingRequest_LogShouldContainRequestHeaders() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsExpectedRequestHeaders()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainResponseHeaders() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainResponseHeaders() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_NetworkLogger_whenLoggingRequest_LogShouldContainTimeAndDateRequestWasMade() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainAssociatedResponseError() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsErrorDescriptionForFailedResponse()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldNotContainAnyResponseError() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogDoesNotContainErrorDescription()
    }
    
    func test_NetworkLogger_whenLoggingRequest_LogShouldContainNameOfNetworkRequestBeingPerformed() {
        // given
        givenRequest(ofType: .getMovieGenres)
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
    }
    
    func test_NetworkLogger_whenLoggingMultipleRequests_LogsShouldContainNamesOfAllNetworkRequestsBeingPerformed() {
        // given
        givenRequest(ofType: .getPopularMovies)
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()

        // given
        givenRequest(ofType: .getTopRatedMovies)
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
    }

    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: .getMovieGenres)
        givenSuccessfulResponse(ofType: .getMovieGenres)
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: .getMovieGenres)
        givenFailedResponse(ofType: .getMovieGenres)
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    // MARK: - Given
    
    private func givenRequest(ofType type: RequestName = .get) {
        self.requestType = type

        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")

        self.request = NetworkRequest(urlRequest: urlRequest,
                                      requestName: type)
        
    }
    
    private func givenSuccessfulResponse(ofType type: RequestName = .get) {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                         statusCode: 200,
                                         httpVersion: "1.1",
                                         headerFields: ["Date": "Thu, 07 Jul 2022 15:51:17 GMT"]
                                         )!
        self.response = NetworkResponse(urlResponse: urlResponse,
                                        requestName: type)
    }
    
    private func givenFailedResponse(ofType type: RequestName = .get) {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                        statusCode: 400,
                                        httpVersion: "1.1",
                                        headerFields: ["Date": "Thu, 07 Jul 2022 15:51:17 GMT"]
                                        )!
        self.response = NetworkResponse(urlResponse: urlResponse,
                                        requestName: type)
        self.networkError = NetworkErrorMock.someError
    }
    
    private func givenFailedResponseWithUnrecognisedStatusCode(requestType type: RequestName = .get) {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                         statusCode: 9999,
                                         httpVersion: "1.1",
                                         headerFields: [:]
                                         )!
        self.response = NetworkResponse(urlResponse: urlResponse,
                                        requestName: type)
    }
    
    // MARK: - When
    
    private func whenRequestIsLogged() {
        guard let request = self.request else {
            XCTFail("request should be non optional at this point of execution")
            return
        }

        self.sut?.log(request)
    }
    
    private func whenResponseIsLogged() {
        guard let response = self.response else {
            XCTFail("response should be non optional at this point of execution")
            return
        }
        
        if self.networkError != nil {
            self.sut?.log(response, withError: self.networkError)
        } else {
            self.sut?.log(response)
        }
    }
        
    // MARK: - Then
    
    private func thenEnsureLogsCreated(count: Int) {
        XCTAssertEqual(self.sut?.logs.count, count)
    }
    
    private func thenEnsureLogStatusCode(is status: Int) {
        XCTAssertEqual(self.lastLogCreated()?.status, status)
    }
    
    private func thenEnsureLogStatusCodeIsNotSuccess() {
        XCTAssertNotEqual(self.lastLogCreated()?.status, 200)
    }
    
    private func thenEnsureLogContainsSuccessfulStatusCodeDescription() {
        XCTAssertEqual("OK", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogContainsFailedStatusCodeDescription() {
        XCTAssertEqual("Bad Request", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogContainsEmptyStringAsStatusCodeDescription() {
        XCTAssertEqual("", self.lastLogCreated()?.statusDescription)
    }
    
    private func thenEnsureLogTypeIsRequest() {
        XCTAssertEqual(self.lastLogCreated()?.logType, .request)
    }

    private func thenEnsureLogTypeIsResponse() {
        XCTAssertEqual(self.lastLogCreated()?.logType, .response)
    }
    
    private func thenEnsureLogContainsExpectedRequestHeaders() {
        XCTAssertEqual(self.lastLogCreated()?.headers, self.request?.urlRequest.allHTTPHeaderFields)
    }
    
    private func thenEnsureLogContainsExpectedResponseHeaders() {
        XCTAssertEqual(self.lastLogCreated()?.headers, self.response?.urlResponse.allHeaderFields as? [String: String])
    }
    
    private func thenEnsureLogContainsTimeAndDate() {
        XCTAssertEqual(self.lastLogCreated()?.timeDate.ISO8601Format(), Date().ISO8601Format())
    }
    
    private func thenEnsureLogContainsErrorDescriptionForFailedResponse() {
        XCTAssertEqual(self.lastLogCreated()?.errorDescription, self.networkError?.localizedDescription)
    }
    
    private func thenEnsureLogDoesNotContainErrorDescription() {
        XCTAssertNil(self.lastLogCreated()?.errorDescription)
    }
    
    private func thenEnsureLogContainsNameOfNetworkRequestBeingPerformed() {
        XCTAssertEqual(self.lastLogCreated()?.requestName, self.requestType)
    }
    
    private func thenEnsureLogContainsNameOfRequestThatResultedInResponse() {
        XCTAssertEqual(self.requestType, self.response?.requestName)
    }
    
    // MARK: - Helpers
    
    private func lastLogCreated() -> Log? {
        self.sut?.logs.last
    }


}

// TODO: Tests

// Log records request type, e.g. GetMovieGenres

/*
 
 Log records URL Request details such as
        ===
        - Time/Date
        - Request Type e.g. GetMovieGenresRequest
        - Sending [GET/POST/DELETE] to [target URL]
        - Headers:
        - Body: None
        ===
 */

/*
 
 Log URL Response details such as
        ===
        - Time/Date
        - Request Type
        - Received from [target URL]
        - Status (e.g. 200, 404)
        - Parsing (OK? Error?)
        - Headers:
        - Body: [Raw JSON]

 */



// TODO: Create log printer

// Log Printer should pretty print Log items with emojis and formatting



