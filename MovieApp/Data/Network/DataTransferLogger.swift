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
    var logs: [Log] = []
}


// MARK: - DataTransferLoggerProtocol

extension DataTransferLogger: DataTransferLoggerProtocol {
    func log(_ log: String) {
        let logToSave = Log(text: log, status: 200)
        self.logs.append(logToSave)
    }
}

struct Log: Equatable {
    let text: String
    let status: Int
}
