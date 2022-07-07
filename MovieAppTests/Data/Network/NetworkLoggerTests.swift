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
    private var request: URLRequest?
    private var response: HTTPURLResponse?
    
    // MARK: - Setup
    
    override func setUp() {
        self.sut = NetworkLogger()
        
        self.url = URL(string: "www.example.com")
    }
    
    override func tearDown() {
        self.sut = nil
        
        self.url = nil
        self.request = nil
        self.response = nil
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
    
    func test_NetworkLogger_whenLoggingRequest_LogShouldContainHeaders() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsExpectedHeaders()
    }

    // MARK: - Given
    
    private func givenRequest() {
        self.request = URLRequest(url: self.url!)
        self.request?.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
    }
    
    private func givenSuccessfulResponse() {
        self.response = HTTPURLResponse(url: self.url!,
                                        statusCode: 200,
                                        httpVersion: "1.1",
                                        headerFields: [:]
                                        )!
    }
    
    private func givenFailedResponse() {
        self.response = HTTPURLResponse(url: self.url!,
                                        statusCode: 400,
                                        httpVersion: "1.1",
                                        headerFields: [:]
                                        )!
    }
    
    private func givenFailedResponseWithUnrecognisedStatusCode() {
        self.response = HTTPURLResponse(url: self.url!,
                                        statusCode: 9999,
                                        httpVersion: "1.1",
                                        headerFields: [:]
                                        )!
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

        self.sut?.log(response)
    }
    
    // MARK: - Then
    
    private func thenEnsureLogsCreated(count: Int) {
        XCTAssertEqual(self.sut?.logs.count, count)
    }
    
    private func thenEnsureLogStatusCode(is status: Int) {
        XCTAssertEqual(self.sut?.logs[0].status, status)
    }
    
    private func thenEnsureLogStatusCodeIsNotSuccess() {
        XCTAssertNotEqual(self.sut?.logs[0].status, 200)
    }
    
    private func thenEnsureLogContainsSuccessfulStatusCodeDescription() {
        XCTAssertEqual("OK", sut?.logs[0].statusDescription)
    }
    
    private func thenEnsureLogContainsFailedStatusCodeDescription() {
        XCTAssertEqual("Bad Request", sut?.logs[0].statusDescription)
    }
    
    private func thenEnsureLogContainsEmptyStringAsStatusCodeDescription() {
        XCTAssertEqual("", sut?.logs[0].statusDescription)
    }
    
    private func thenEnsureLogTypeIsRequest() {
        XCTAssertEqual(self.sut?.logs[0].type, .request)
    }

    private func thenEnsureLogTypeIsResponse() {
        XCTAssertEqual(self.sut?.logs[0].type, .response)
    }
    
    private func thenEnsureLogContainsExpectedHeaders() {
        XCTAssertEqual(self.sut?.logs[0].headers, self.request?.allHTTPHeaderFields)
    }
    
    // MARK: - Helpers
    
    


}

// TODO: Tests

// Log records success / failure

// Log records request type, e.g. GetMovieGenres

// Log records error if present

// Log records time and date

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



