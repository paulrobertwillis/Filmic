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
    
    private var sut: NetworkLogPrinter?
    
    private var requestLog: Log?
    private var responseLog: Log?
    
    // MARK: - Lifecycle
    
    override func setUp() {
        self.sut = NetworkLogPrinter()
    }
    
    override func tearDown() {
        self.sut = nil
        
        self.requestLog = nil
        self.responseLog = nil
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

        let formattedDateTime = "🕔 \(requestLog!.dateTime.description)"

        // then
        XCTAssertTrue(self.sut!.printLineArray.contains(formattedDateTime))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestNameSectionAsFormattedString() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        let formattedRequestName = "⌨️ Request Name: \(requestLog.requestName)"
        
        XCTAssertTrue(self.sut!.printLineArray.contains(formattedRequestName))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintSendingRequestSectionAsFormattedString() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        let formattedMethodTypeAndURL = "⬆️ Sending \(requestLog.httpMethodType!) to: \(requestLog.url!)"

        XCTAssertTrue(self.sut!.printLineArray.contains(formattedMethodTypeAndURL))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestHeadersSectionAsFormattedString() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com"),
                             headers: [
                                "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                                "Gateway-Status": "OK",
                                "Example-Header": "Value"
                             ]
        )
        
        whenPrintRequest(requestLog)

        let formattedHeaders = "🧠 Headers: \(requestLog.headers!)"

        XCTAssertTrue(self.sut!.printLineArray.contains(formattedHeaders))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestBodySectionAsNone() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        let formattedBody = "🏋️ Body: None"

        XCTAssertTrue(self.sut!.printLineArray.contains(formattedBody))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintLastSectionAsDashedDivider() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        XCTAssertEqual(self.sut?.printLineArray.last, "----")
    }

    func test_NetworkLogPrinter_whenPrintsRequestWithNoMethodType_shouldNotPrintSendingRequestSectionIfMethodTypeIsNil() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog.httpMethodType)) to: \(String(describing: requestLog.url))"

        XCTAssertFalse(self.sut!.printLineArray.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithNoUrl_shouldNotPrintSendingRequestSectionIfUrlIsNil() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
        
        whenPrintRequest(requestLog)

        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog.httpMethodType)) to: \(String(describing: requestLog.url))"

        XCTAssertFalse(self.sut!.printLineArray.contains(formattedMethodTypeAndURL), "should only print this line if both httpMethodType and Url are not nil")
    }

    
    func test_NetworkLogPrinter_whenPrintsRequestWithNoHeaders_shouldNotPrintSectionIfHeadersIsNil() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )

        whenPrintRequest(requestLog)

        let formattedHeaders = "🧠 Headers: \(String(describing: requestLog.headers))"

        XCTAssertFalse(self.sut!.printLineArray.contains(formattedHeaders), "should only print this line if headers property is not nil")
    }

    func test_NetworkLogPrinter_whenPrintsRequestWithDateTime_shouldPrintDateTimeSectionExactlyOnce() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )

        whenPrintRequest(requestLog)

        let formattedDateTime = "🕔 \(requestLog.dateTime.description)"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedDateTime }.count

        XCTAssertEqual(occurrences, 1)
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithRequestName_shouldPrintRequestNameSectionExactlyOnce() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )

        whenPrintRequest(requestLog)

        let formattedRequestName = "⌨️ Request Name: \(requestLog.requestName)"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedRequestName }.count

        XCTAssertEqual(occurrences, 1)
    }
    
    func test_NetworkLogPrinter_whenPrintsRequestWithMethodTypeAndNoURL_shouldNotPrintSendingRequestSection() {
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: nil
        )

        whenPrintRequest(requestLog)

        let formattedMethodTypeAndURL = "⬆️ Sending \(String(describing: requestLog.httpMethodType)) to: \(String(describing: requestLog.url))"
        let occurrences = self.sut?.printLineArray.filter { $0 == formattedMethodTypeAndURL }.count

        XCTAssertEqual(occurrences, 0)
    }
    
    
    
    // MARK: - Given
    
    private func givenRequestLogCreated() {
        self.requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             url: URL(string: "www.example.com")
        )
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
    
    private func formattedDateTime(for log: Log) -> String {
        "🕔 \(log.dateTime.description)"
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

// TODO: Create log printer

// Log Printer should pretty print Log items with emojis and formatting
