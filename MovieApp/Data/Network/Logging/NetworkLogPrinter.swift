//
//  NetworkLogPrinter.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

protocol NetworkLogPrinterProtocol {
    func printToDebugArea(_ log: Log)
}

class NetworkLogPrinter: NetworkLogPrinterProtocol {
    
    enum SectionEmojis: String {
        case dateTime = "🕔"
        case requestName = "⌨️"
        case sendingRequest = "⬆️"
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
    
    func printToDebugArea(_ log: Log) {
        self.printDivider()
        
        self.printDateTime(log.dateTime)
        
        self.printRequestName(log.requestName)
        
        if let httpMethodType = log.httpMethodType,
           let url = log.url {
            self.printHTTPMethodTypeAndURL(httpMethodType: httpMethodType, url: url)
        }
        
        if let headers = log.headers {
            self.printHeaders(headers)
        }

        self.printBody(log.body)
        
        self.printDivider()
    }
    
    // MARK: - Helpers
    
    private func printDivider() {
        self.output.write("----")
    }
    
    private func printDateTime(_ date: Date) {
        let formattedDateTime = "\(SectionEmojis.dateTime.rawValue) \(date)"
        self.output.write(formattedDateTime)
    }
    
    private func printRequestName(_ requestName: String) {
        let formattedRequestName = "\(SectionEmojis.requestName.rawValue) Request Name: \(requestName)"
        self.output.write(formattedRequestName)
    }
    
    private func printHTTPMethodTypeAndURL(httpMethodType: String, url: String) {
        let formattedMethodTypeAndURL = "\(SectionEmojis.sendingRequest.rawValue) Sending \(httpMethodType) to: \(url)"
        self.output.write(formattedMethodTypeAndURL)
    }
    
    private func printHeaders(_ headers: [String: String]) {
        let formattedHeaders = "\(SectionEmojis.headers.rawValue) Headers: \(headers)"
        self.output.write(formattedHeaders)
    }
    
    private func printBody(_ body: String?) {
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

