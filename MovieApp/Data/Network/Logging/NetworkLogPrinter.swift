//
//  NetworkLogPrinter.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

protocol NetworkLogPrinterProtocol {
    func recordLog(_ log: Log)
}

class NetworkLogPrinter: NetworkLogPrinterProtocol {
    
    enum SectionEmojis: String {
        case dateTime = "🕔"
        case requestName = "⌨️"
        case sendingRequest = "⬆️"
        case receivingRequest = "⬇️"
        case headers = "🧠"
        case body = "🏋️"
    }
    
    // MARK: - Private Properties
    
    private let output: LogOutputProtocol
    
    // MARK: - Lifecycle
    
    init(output: LogOutputProtocol) {
        self.output = output
    }
    
    // MARK: - API
    
    func recordLog(_ log: Log) {
        switch log.logType {
        case .request:
            self.recordRequest(log)
        case .response:
            self.recordResponse(log)
        }
    }
    
    // MARK: - Helpers
    
    private func recordRequest(_ log: Log) {
        self.printDividerSection()
        self.printDateTimeSection(log.dateTime)
        self.printRequestNameSection(log.requestName)
        
        if let httpMethodType = log.httpMethodType,
           let url = log.url {
            self.printDataTransferSection(httpMethodType: httpMethodType, url: url)
        }
        
        if let headers = log.headers {
            self.printHeadersSection(headers)
        }

        self.printBodySection(log.body)
        self.printDividerSection()
    }
    
    private func recordResponse(_ log: Log) {
        self.printDividerSection()
        self.printDateTimeSection(log.dateTime)
        self.printRequestNameSection(log.requestName)
        
        if let url = log.url {
            self.printResponseDataTransferSection(url: url)
        }
        
        if let headers = log.headers {
            self.printHeadersSection(headers)
        }

        self.printBodySection(log.body)
        self.printDividerSection()

    }
    
    private func printDividerSection() {
        self.output.write("----")
    }
    
    private func printDateTimeSection(_ date: Date) {
        let formattedDateTime = "\(SectionEmojis.dateTime.rawValue) \(date)"
        self.output.write(formattedDateTime)
    }
    
    private func printRequestNameSection(_ requestName: String) {
        let formattedRequestName = "\(SectionEmojis.requestName.rawValue) Request Name: \(requestName)"
        self.output.write(formattedRequestName)
    }
    
    private func printDataTransferSection(httpMethodType: String, url: String) {
        let formattedMethodTypeAndURL = "\(SectionEmojis.sendingRequest.rawValue) Sending \(httpMethodType) to: \(url)"
        self.output.write(formattedMethodTypeAndURL)
    }
    
    private func printResponseDataTransferSection(url: String) {
        let formattedMethodTypeAndURL = "\(SectionEmojis.receivingRequest.rawValue) Received from \(url)"
        self.output.write(formattedMethodTypeAndURL)
    }
    
    private func printHeadersSection(_ headers: [String: String]) {
        let formattedHeaders = "\(SectionEmojis.headers.rawValue) Headers: \(headers)"
        self.output.write(formattedHeaders)
    }
    
    private func printBodySection(_ body: String?) {
        let formattedBody = "\(SectionEmojis.body.rawValue) Body: None"
        self.output.write(formattedBody)
    }
}

// TODO: Move emoji to enum PrinterEmojis with case for each section

protocol LogOutputProtocol {
    func write(_ string: String)
}

class ConsoleLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        print(string)
    }
}

class FileLogOutput: LogOutputProtocol {
    func write(_ string: String) {
        // do later when want to do to file
    }
}


// create mock LogOutput and put the array there

// for prod/dev, can have different targets or a switch ...? By default, just use ifdebug.

