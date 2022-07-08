//
//  NetworkLogPrinterMock.swift
//  MovieAppTests
//
//  Created by Paul on 08/07/2022.
//

import Foundation
@testable import MovieApp

class NetworkLogPrinterMock: NetworkLogPrinterProtocol {
    var printedLog: String = ""
    
    // MARK: - printToDebugArea
    
    var printToDebugAreaCallCount = 0
    
    // log
    var printToDebugAreaLogParameterReceived: Log?
    
    func printToDebugArea(_ log: Log) {
        self.printToDebugAreaCallCount += 1
        self.printToDebugAreaLogParameterReceived = log
    }
}
