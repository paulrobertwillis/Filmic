//
//  DataTransferLogger.swift
//  MovieApp
//
//  Created by Paul on 06/07/2022.
//

import Foundation

protocol DataTransferLoggerProtocol {
    func log(_ log: String)
}

class DataTransferLogger {
    var mostRecentLog: Log?
}


// MARK: - DataTransferLoggerProtocol

extension DataTransferLogger: DataTransferLoggerProtocol {
    func log(_ log: String) {
        self.mostRecentLog = Log(text: log)
    }
}

struct Log: Equatable {
    let text: String
}
