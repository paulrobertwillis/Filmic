//
//  NetworkLogPrinterTests.swift
//  MovieAppTests
//
//  Created by Paul on 08/07/2022.
//

import XCTest
@testable import MovieApp

class NetworkLogPrinterTests: XCTestCase {
    
    // MARK: - Private Properties
    
    private var output: ConsoleLogOutputMock?
    private var sut: NetworkLogPrinter?
    
    private var requestLog: Log?
    private var responseLog: Log?
    
    private var formattedRequestStrings: FormattedRequestStrings?
    private var formattedResponseStrings: FormattedResponseStrings?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        self.output = ConsoleLogOutputMock()
        self.sut = NetworkLogPrinter(output: self.output!)
    }
    
    override func tearDown() {
        self.sut = nil
        
        self.requestLog = nil
        self.responseLog = nil
        
        self.formattedRequestStrings = nil
        self.formattedResponseStrings = nil
    }
    
    // MARK: - Tests: Request SectionFormatting
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintFirstSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsFirstSectionAsDashedDivider()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintDateTimeSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDateTimeSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintRequestNameSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestNameSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequestWithMethodTypeAndUrl_shouldPrintSendingRequestSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithMethodTypeAndUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsSendingRequestSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequestWithHeaders_shouldPrintRequestHeadersSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithHeaders()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsHeadersSectionAsFormattedString()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintRequestBodySectionAsNone() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestBodySectionAsNone()
    }
    
    func test_RequestSectionFormatting_whenPrintsRequest_shouldPrintLastSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsLastSectionAsDashedDivider()
    }
    
    // MARK: - Optional Handling
    
    func test_OptionalHandling_whenPrintsRequestWithNoMethodType_shouldNotPrintSendingRequestSectionIfMethodTypeIsNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintSendingRequestSection()
    }
    
    func test_OptionalHandling_whenPrintsRequestWithNoURL_shouldNotPrintSendingRequestSection() {
        // given
        givenRequestLogCreatedWithNoUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintSendingRequestSection()
    }
    
    func test_OptionalHandling_whenPrintsRequestWithNoMethodTypeAndNoUrl_shouldNotPrintSendingRequestSectionIfMethodTypeAndUrlAreNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintSendingRequestSection()
    }
    
    
    func test_OptionalHandling_whenPrintsRequestWithNoHeaders_shouldNotPrintHeadersSectionIfHeadersIsNil() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsureDoesNotPrintHeadersSection()
    }
    
    // MARK: - Tests: Output Call Count
    
    func test_OutputCallCount_whenPrintsRequest_shouldPrintDateTimeSectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsDateTimeSectionExactlyOnce()
    }
    
    func test_OutputCallCount_whenPrintsRequest_shouldPrintRequestNameSectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsRequestNameSectionExactlyOnce()
    }
    
    func test_OutputCallCount_whenPrintsRequestWithMethodTypeAndUrl_shouldPrintSendingRequestSectionExactlyOnce() {
        // given
        givenRequestLogCreatedWithMethodTypeAndUrl()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsSendingRequestSectionExactlyOnce()
    }
    
    func test_OutputCallCount_whenPrintsRequestWithHeaders_shouldPrintHeadersSectionExactlyOnce() {
        // given
        givenRequestLogCreatedWithHeaders()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsHeadersSectionExactlyOnce()
    }
    
    func test_OutputCallCount_whenPrintsRequest_shouldPrintBodySectionExactlyOnce() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        thenEnsurePrintsBodySectionExactlyOnce()
    }
    
    // MARK: - Given
    
    private func givenRequestLogCreated() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com")
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithMethodTypeAndUrl() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      httpMethodType: "GET",
                      url: URL(string: "www.example.com")
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithNoUrl() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      httpMethodType: "GET",
                      url: nil
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    private func givenRequestLogCreatedWithHeaders() {
        let log = Log(logType: .request,
                      requestName: .getMovieGenres,
                      url: URL(string: "www.example.com"),
                      headers: [
                        "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                        "Gateway-Status": "OK",
                        "Example-Header": "Value"
                      ]
        )
        self.requestLog = log
        self.formattedRequestStrings = FormattedRequestStrings(log: log)
    }
    
    // MARK: - When
    
    private func whenPrintRequest(_ log: Log? = nil) {
        if let log = log {
            self.sut?.printToDebugArea(log)
        } else {
            self.sut?.printToDebugArea(self.requestLog!)
        }
        
    }
    
    // MARK: - Then: EnsurePrintsFormattedStrings
    
    private func thenEnsurePrintsFirstSectionAsDashedDivider() {
        guard let output = self.output else { XCTFail(); return }
        
        XCTAssertEqual(output.writeStringParametersReceived.first, "----")
    }
    
    private func thenEnsurePrintsDateTimeSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.dateTime()))
    }
    
    private func thenEnsurePrintsRequestNameSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.requestName()))
    }
    
    private func thenEnsurePrintsSendingRequestSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.httpMethodTypeAndUrl()))
    }
    
    private func thenEnsurePrintsHeadersSectionAsFormattedString() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.headers()))
    }
    
    private func thenEnsurePrintsRequestBodySectionAsNone() {
        guard let output = self.output else { XCTFail(); return }
        guard let formattedStrings = self.formattedRequestStrings else { XCTFail(); return }
        
        XCTAssertTrue(output.writeStringParametersReceived.contains(formattedStrings.body()))
    }
    
    private func thenEnsurePrintsLastSectionAsDashedDivider() {
        guard let output = self.output else { XCTFail(); return }
        
        XCTAssertEqual(output.writeStringParametersReceived.last, "----")
    }
    
    // MARK: - Then: EnsureDoesNotPrint
    
    private func thenEnsureDoesNotPrintSendingRequestSection() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: log.httpMethodType)) to: \(String(describing: log.url))"
                
        XCTAssertFalse(output.writeStringParametersReceived.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }
    
    private func thenEnsureDoesNotPrintHeadersSection() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedHeaders = "🧠 Headers: \(String(describing: log.headers))"
        
        XCTAssertFalse(output.writeStringParametersReceived.contains(formattedHeaders), "should only print this line if headers property is not nil")
    }
    
    // MARK: - Then: EnsurePrintsExactlyOnce
    
    private func thenEnsurePrintsDateTimeSectionExactlyOnce() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedDateTime = "🕔 \(log.dateTime.description)"
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedDateTime }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsRequestNameSectionExactlyOnce() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedRequestName = "⌨️ Request Name: \(log.requestName)"
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedRequestName }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsSendingRequestSectionExactlyOnce() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedSendingRequest = "⬆️ Sending \(log.httpMethodType!) to: \(log.url!)"
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedSendingRequest }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsHeadersSectionExactlyOnce() {
        guard let output = self.output else { XCTFail(); return }
        guard let log = self.requestLog else { XCTFail(); return }
        
        let formattedHeaders = "🧠 Headers: \(log.headers!)"
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedHeaders }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    private func thenEnsurePrintsBodySectionExactlyOnce() {
        guard let output = self.output else { XCTFail(); return }
        
        let formattedBody = "🏋️ Body: None"
        let occurrences = output.writeStringParametersReceived.filter { $0 == formattedBody }.count
        
        XCTAssertEqual(occurrences, 1)
    }
    
    // MARK: - Helpers
    
    struct FormattedRequestStrings {
        let log: Log
        
        func dateTime() -> String {
            "🕔 \(self.log.dateTime.description)"
        }
        
        func requestName() -> String {
            "⌨️ Request Name: \(self.log.requestName)"
        }
        
        func httpMethodTypeAndUrl() -> String {
            guard
                let httpMethodType = self.log.httpMethodType,
                let url = self.log.url
            else {
                XCTFail()
                return ""
            }
            
            return "⬆️ Sending \(httpMethodType) to: \(url)"
        }
        
        func headers() -> String {
            guard let headers = self.log.headers else {
                XCTFail()
                return ""
            }
            
            return "🧠 Headers: \(String(describing: headers))"
        }
        
        func body() -> String {
            "🏋️ Body: None"
        }
    }
    
    struct FormattedResponseStrings {
        
    }
}

// should handle optionals!

// should handle requests and responses

// should print each line only once

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

