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
    var printLineArray: [String] = []
    
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

        for line in printLineArray {
            print(line)
        }
    }
    
    private func printDivider() {
        self.printLineArray.append("----")
    }
    
    private func printDateTime(_ date: Date) {
        let formattedDateTime = "🕔 \(date)"
        self.printLineArray.append(formattedDateTime)
    }
    
    private func printRequestName(_ requestName: String) {
        let formattedRequestName = "⌨️ Request Name: \(requestName)"
        self.printLineArray.append(formattedRequestName)
    }
    
    private func printHTTPMethodTypeAndURL(httpMethodType: String, url: String) {
        let formattedMethodTypeAndURL = "⬆️ Sending \(httpMethodType) to: \(url)"
        self.printLineArray.append(formattedMethodTypeAndURL)
    }
    
    private func printHeaders(_ headers: [String: String]) {
        let formattedHeaders = "🧠 Headers: \(headers)"
        self.printLineArray.append(formattedHeaders)
    }
    
    private func printBody(_ body: String?) {
        let formattedBody = "🏋️ Body: None"
        self.printLineArray.append(formattedBody)
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

