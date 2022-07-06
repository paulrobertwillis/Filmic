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

    func test_DataTransferLogger_whenLogsResponseStatus_shouldCreateLog() {
        let sut = DataTransferLogger()
        
        sut.log("successful request")
        let expectedLog = Log(text: "successful request")
        
        
        XCTAssertEqual(expectedLog, sut.mostRecentLog)
    }
    
}
