//
//  DataTransferLoggerTests.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
import XCTest
@testable import MovieApp

class DataTransferLoggerTests: XCTestCase {

    func test_DataTransferLogger_whenLoggingResponseStatus_shouldCreateLog() {
        let sut = DataTransferLogger()
        
        sut.log("successful response")
        
        XCTAssertEqual(sut.logs.count, 1)
    }
    
    func test_DataTransferLogger_whenLoggingMultipleResponseStatuses_shouldCreateMultipleLogs() {
        let sut = DataTransferLogger()
        
        sut.log("successful response 1")
        sut.log("successful response 2")
        
        XCTAssertEqual(sut.logs.count, 2)
    }
    
    func test_DataTransferLogger_whenLoggingSuccessfulResponse_LogShouldContainSuccessStatus() {
        let sut = DataTransferLogger()
        
        sut.log("successful response")
        
        XCTAssertEqual(sut.logs[0].status, 200)
    }
    
    func test_DataTransferLogger_whenLoggingFailedResponse_LogShouldContainFailedStatus() {
        let sut = DataTransferLogger()
        
        sut.log("failed response")
        
        XCTAssertNotEqual(sut.logs[0].status, 200)

    }
    
    // should contain specific failed status depending on error type
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
