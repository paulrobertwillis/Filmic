//
//  NetworkLogPrinterTests.swift
//  MovieAppTests
//
//  Created by Paul on 08/07/2022.
//

import XCTest
@testable import MovieApp

class NetworkLogPrinterTests: XCTestCase {
    
    func test_NetworkLogPrinter_initialises() {
        let _ = NetworkLogPrinter()
        
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintFirstLineAsDashedDivider() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)

        XCTAssertEqual(printer.printLineArray.first, "----")
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintDateTimeAsFormattedString() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)
        
        let formattedDateTime = "🕔 \(requestLog.dateTime.description)"

        XCTAssertTrue(printer.printLineArray.contains(formattedDateTime))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestNameAsFormattedString() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)
        
        let formattedRequestName = "⌨️ Request Name: \(requestLog.requestName)"
        
        XCTAssertTrue(printer.printLineArray.contains(formattedRequestName))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestHTTPMethodTypeAndRequestURLAsFormattedString() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)
        
        let formattedMethodTypeAndURL = "⬆️ Sending \(requestLog.httpMethodType) to: \(requestLog.url)"

        XCTAssertTrue(printer.printLineArray.contains(formattedMethodTypeAndURL))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestHeadersAsFormattedString() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com"),
                             headers: [
                                "Date": "Thu, 07 Jul 2022 15:51:16 GMT",
                                "Gateway-Status": "OK",
                                "Example-Header": "Value"
                             ]
        )
        
        printer.printToDebugArea(requestLog)
        
        let formattedHeaders = "🧠 Headers: \(requestLog.headers)"

        XCTAssertTrue(printer.printLineArray.contains(formattedHeaders))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintRequestBodyAsNone() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)
        
        let formattedBody = "🏋️ Body: None"

        XCTAssertTrue(printer.printLineArray.contains(formattedBody))
    }
    
    func test_NetworkLogPrinter_whenPrintsRequest_shouldPrintLastLineAsDashedDivider() {
        let printer = NetworkLogPrinter()
        
        let requestLog = Log(logType: .request,
                             requestName: .getMovieGenres,
                             httpMethodType: "GET",
                             url: URL(string: "www.example.com")
        )
        
        printer.printToDebugArea(requestLog)

        XCTAssertEqual(printer.printLineArray.last, "----")
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
