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
    
    // MARK: - Tests
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintFirstSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()
        
        // then
        XCTAssertEqual(self.sut?.printLineArray.first, "----")
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintDateTimeSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest()

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(self.formattedRequestStrings!.dateTime()))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestNameSectionAsFormattedString() {
        // given
        givenRequestLogCreated()
        
        // when
        whenPrintRequest(requestLog)

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(self.formattedRequestStrings!.requestName()))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithMethodTypeAndUrl_shouldPrintSendingRequestSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithMethodTypeAndUrl()
        
        // when
        whenPrintRequest(requestLog)

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(self.formattedRequestStrings!.httpMethodTypeAndUrl()))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithHeaders_shouldPrintRequestHeadersSectionAsFormattedString() {
        // given
        givenRequestLogCreatedWithHeaders()
        
        // when
        whenPrintRequest(requestLog)

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(self.formattedRequestStrings!.headers()))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestBodySectionAsNone() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(self.formattedRequestStrings!.body()))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintLastSectionAsDashedDivider() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        // then
        XCTAssertEqual(self.sut?.printLineArray.last, "----")
    }

    func test_NetworkLogPrinter_whenPrintsRequestWithNoMethodType_shouldNotPrintSendingRequestSectionIfMethodTypeIsNil() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        // then
        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog!.httpMethodType)) to: \(String(describing: requestLog!.url))"

        XCTAssertFalse(self.sut!.printLineArray.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithNoUrl_shouldNotPrintSendingRequestSectionIfUrlIsNil() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        // then
        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog!.httpMethodType)) to: \(String(describing: requestLog!.url))"

        XCTAssertFalse(self.sut!.printLineArray.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }

    
    func test_NetworkLogPrinter_whenPrintsRequestWithNoHeaders_shouldNotPrintSectionIfHeadersIsNil() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        let formattedHeaders = "🧠 Headers: \(String(describing: requestLog!.headers))"

        // then
        XCTAssertFalse(self.sut!.printLineArray.contains(formattedHeaders), "should only print this line if headers property is not nil")
    }

    func test_NetworkLogPrinter_whenPrintsRequestWithDateTime_shouldPrintDateTimeSectionExactlyOnce() {
        // given
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        let formattedDateTime = "🕔 \(requestLog!.dateTime.description)"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedDateTime }.count

        // then
        XCTAssertEqual(occurrences, 1)
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithRequestName_shouldPrintRequestNameSectionExactlyOnce() {
        // givne
        givenRequestLogCreated()

        // when
        whenPrintRequest(requestLog)

        let formattedRequestName = "⌨️ Request Name: \(requestLog!.requestName)"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedRequestName }.count

        // then
        XCTAssertEqual(occurrences, 1)
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithMethodTypeAndNoURL_shouldNotPrintSendingRequestSection() {
        // given
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: nil
        )

        // when
        whenPrintRequest(requestLog)

        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog.httpMethodType)) to: \(String(describing: requestLog.url))"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedMethodTypeAndURL }.count

        // then
        XCTAssertEqual(occurrences, 0)
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
    
    // MARK: - Then
    
    
    
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
        
//    private func formattedDateTime(for logType: Log.LogType) -> String {
//        if logType == .request {
//            return "🕔 \(self.requestLog!.dateTime.description)"
//        } else {
//            return "🕔 \(self.responseLog!.dateTime.description)"
//        }
//    }
//
//    private func formattedRequestName(for logType: Log.LogType) -> String {
//        if logType == .request {
//            return "⌨️ Request Name: \(requestLog!.requestName)"
//        } else {
//            return "⌨️ Request Name: \(responseLog!.requestName)"
//        }
//    }
//
//    private func formattedMethodTypeAndURL(for logType: Log.LogType) -> String {
//        if logType == .request {
//            return "⬆️ Sending \(requestLog!.httpMethodType!) to: \(requestLog!.url!)"
//        } else {
//            return "⬆️ Sending \(responseLog!.httpMethodType!) to: \(responseLog!.url!)"
//        }
//    }
//
//    private func formattedHeaders(for logType: Log.LogType) -> String {
//        if logType == .request {
//            return "🧠 Headers: \(String(describing: requestLog!.headers))"
//        } else {
//            return "🧠 Headers: \(String(describing: responseLog!.headers))"
//        }
//    }
//
//    private func formattedBody(for logType: Log.LogType) -> String {
//        if logType == .request {
//            return "🏋️ Body: None"
//        } else {
//            return ""
//        }
//    }
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

// TODO: Create log printer

// Log Printer should pretty print Log items with emojis and formatting


