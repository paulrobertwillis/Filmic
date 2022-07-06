//
//  DataTransferLoggerMock.swift
//  MovieAppTests
//
//  Created by Paul on 06/07/2022.
//

import Foundation
@testable import MovieApp

class DataTransferLoggerMock: DataTransferLoggerProtocol {
    var mostRecentLog: String?
    var logs: [String] = []
    
    func log(_ log: String) {
        self.mostRecentLog = log
        self.logs.append(log)
    }
}
