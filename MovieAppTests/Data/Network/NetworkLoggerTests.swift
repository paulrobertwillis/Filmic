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
    
    private var requestName: RequestName?
    private var request: NetworkRequest?
    private var response: NetworkResponse?
    
    private var networkError: NetworkErrorMock?
        
    // MARK: - Setup
    
    override func setUp() {
        self.sut = NetworkLogger()
        
        self.url = URL(string: "www.example.com")
    }
    
    override func tearDown() {
        self.sut = nil
        
        self.url = nil
        
        self.requestName = nil
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
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainSuccessStatusCode() {
        // given
        givenSuccessfulResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogStatusCode(is: 200)
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldNotContainSuccessfulStatusCode() {
        // given
        givenFailedResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogStatusCodeIsNotSuccess()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsSuccessfulStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainHTTPResponseStatusCodeDescription() {
        // given
        givenFailedResponse()

        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsFailedStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainEmptyHTTPResponseStatusCodeDescriptionIfResponseStatusCodeNotRecognised() {
        // given
        givenFailedResponseWithUnrecognisedStatusCode()
        
        // when
        whenResponseIsLogged()

        // then
        thenEnsureLogContainsEmptyStringAsStatusCodeDescription()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldBeResponseLog() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldBeResponseLog() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogTypeIsResponse()
    }

    func test_NetworkLogger_whenLoggingRequest_logShouldBeRequestLog() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogTypeIsRequest()
    }
    
    func test_NetworkLogger_whenLoggingRequest_logShouldContainRequestURL() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsRequestURL()
    }
    
    func test_NetworkLogger_whenLoggingRequest_logShouldContainRequestHeaders() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsExpectedRequestHeaders()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainResponseHeaders() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainResponseHeaders() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsExpectedResponseHeaders()
    }
    
    func test_NetworkLogger_whenLoggingRequest_logShouldContainTimeAndDateRequestWasMade() {
        // given
        givenRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainTimeAndDateResponseWasReceived() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsTimeAndDate()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainAssociatedResponseError() {
        // given
        givenFailedResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsErrorDescriptionForFailedResponse()
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldNotContainAnyResponseError() {
        // given
        givenSuccessfulResponse()
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogDoesNotContainErrorDescription()
    }
    
    func test_NetworkLogger_whenLoggingRequest_logShouldContainNameOfNetworkRequestBeingPerformed() {
        // given
        givenRequest(ofType: .getMovieGenres)
        
        // when
        whenRequestIsLogged()
        
        // then
        thenEnsureLogContainsNameOfNetworkRequestBeingPerformed()
    }
    
    func test_NetworkLogger_whenLoggingMultipleRequests_logsShouldContainNamesOfAllNetworkRequestsBeingPerformed() {
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

    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: .getMovieGenres)
        givenSuccessfulResponse(ofType: .getMovieGenres)
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    func test_NetworkLogger_whenLoggingFailedResponse_logShouldContainNameOfRequestThatResultedInResponse() {
        // given
        givenRequest(ofType: .getMovieGenres)
        givenFailedResponse(ofType: .getMovieGenres)
        
        // when
        whenResponseIsLogged()
        
        // then
        thenEnsureLogContainsNameOfRequestThatResultedInResponse()
    }
    
    func test_NetworkLogger_whenLoggingGetRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenGetRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        XCTAssertEqual(HTTPMethodType.get.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    func test_NetworkLogger_whenLoggingPostRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenPostRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        XCTAssertEqual(HTTPMethodType.post.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    func test_NetworkLogger_whenLoggingDeleteRequest_logShouldContainHTTPMethodTypeOfRequest() {
        // given
        givenDeleteRequest()
        
        // when
        whenRequestIsLogged()
        
        // then
        XCTAssertEqual(HTTPMethodType.delete.rawValue, self.lastLogCreated()?.httpMethodType)
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_logShouldContainBodyOfResponseAsJson() {
        // given
        let successResponseData = TMDBResponseMocks.Genres.getGenres.successResponse()
        let jsonResponse = String(data: successResponseData, encoding: .utf8)
        givenSuccessfulResponse(withData: successResponseData)
        
        // when
        whenResponseIsLogged()
        
        // then
        XCTAssertEqual(self.lastLogCreated()?.body, jsonResponse)
    }
    
    // TODO: Change "NetworkLogger" in these test names to something specific to the thing being tested, e.g. LogBody or LogType or ContainsFormattedDate
    
    // MARK: - Given
    
    private func givenRequest(ofType type: RequestName = .get) {
        self.requestName = type
        self.request = NetworkRequest(urlRequest: URLRequest(url: self.url!),
                                      requestName: type)
    }
    
    private func givenGetRequest() {
        self.requestName = .getMovieGenres

        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.get.rawValue
        
        self.request = NetworkRequest(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
    
    private func givenPostRequest() {
        self.requestName = .postMovieRating

        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.post.rawValue
        
        self.request = NetworkRequest(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
    
    private func givenDeleteRequest() {
        self.requestName = .deleteMovieRating

        var urlRequest = URLRequest(url: self.url!)
        urlRequest.addValue("Thu, 07 Jul 2022 15:51:16 GMT", forHTTPHeaderField: "Date")
        urlRequest.httpMethod = HTTPMethodType.delete.rawValue
        
        self.request = NetworkRequest(urlRequest: urlRequest,
                                      requestName: self.requestName!)
    }
        
    private func givenSuccessfulResponse(ofType type: RequestName = .get, withData data: Data? = nil) {
        let urlResponse = HTTPURLResponse(url: self.url!,
                                         statusCode: 200,
                                         httpVersion: "1.1",
                                         headerFields: ["Date": "Thu, 07 Jul 2022 15:51:17 GMT"]
                                         )!
        self.response = NetworkResponse(urlResponse: urlResponse,
                                        requestName: type,
                                        data: data)
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
    
    private func thenEnsureLogContainsRequestURL() {
        XCTAssertEqual(self.lastLogCreated()?.url, self.request?.urlRequest.url?.absoluteString)
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
        XCTAssertEqual(self.lastLogCreated()?.requestName, self.requestName?.rawValue)
    }
    
    private func thenEnsureLogContainsNameOfRequestThatResultedInResponse() {
        XCTAssertEqual(self.lastLogCreated()?.requestName, self.requestName?.rawValue)
    }
    
    // MARK: - Helpers
    
    private func lastLogCreated() -> Log? {
        self.sut?.logs.last
    }
}

// TODO: Tests

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



