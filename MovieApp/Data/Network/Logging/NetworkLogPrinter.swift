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
        
        NSLog("This is an error")
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
