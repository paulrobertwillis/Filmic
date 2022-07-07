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

    func test_NetworkLogger_whenLoggingResponseStatus_shouldCreateLog() {
        let sut = NetworkLogger()
        
        let response = HTTPURLResponse(url: URL(string: "www.example.com")!, statusCode: 200, httpVersion: "1.1", headerFields: [:])!
        
        sut.log(response)

        XCTAssertEqual(sut.logs.count, 1)
    }
    
    func test_NetworkLogger_whenLoggingMultipleResponseStatuses_shouldCreateMultipleLogs() {
        let sut = NetworkLogger()
        
        
        let response = HTTPURLResponse(url: URL(string: "www.example.com")!, statusCode: 200, httpVersion: "1.1", headerFields: [:])!
        
        sut.log(response)
        sut.log(response)

        XCTAssertEqual(sut.logs.count, 2)
    }
    
    func test_NetworkLogger_whenLoggingSuccessfulResponse_LogShouldContainSuccessStatus() {
        let sut = NetworkLogger()
        
        let response = HTTPURLResponse(url: URL(string: "www.example.com")!, statusCode: 200, httpVersion: "1.1", headerFields: [:])!

        sut.log(response)

        XCTAssertEqual(sut.logs[0].status, 200)
    }
    
//    func test_NetworkLogger_whenLoggingFailedResponse_LogShouldContainFailedStatus() {
//        let sut = NetworkLogger()
//
//        sut.log("failed response")
//
//        XCTAssertNotEqual(sut.logs[0].status, 200)
//    }
    
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
