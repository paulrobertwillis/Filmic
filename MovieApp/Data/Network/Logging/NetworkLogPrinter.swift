//
//  NetworkLogPrinter.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

protocol NetworkLogPrinterProtocol {
    func writeLog(_ log: Log)
}

class NetworkLogPrinter: NetworkLogPrinterProtocol {
    
    enum SectionEmojis: String {
        case dateTime = "🕔"
        case requestName = "⌨️"
        case sendingRequest = "⬆️"
        case receivingRequest = "⬇️"
        case status = "📋"
        case statusSuccess = "🟢"
        case statusFailure = "🔴"
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
    
    func writeLog(_ log: Log) {
        self.writeDividerSection()
        self.writeDateTimeSection(log.dateTime)
        self.writeRequestNameSection(log.requestName)
        self.writeDataTransferSection(for: log)
        self.writeStatusSection(for: log)
        
        
        if let headers = log.headers {
            self.writeHeadersSection(headers)
        }

        self.writeBodySection(log.body)
        self.writeDividerSection()

    }
    
    // MARK: - Helpers
        
    
    // MARK: Divider Section
    
    private func writeDividerSection() {
        self.output.write("----")
    }
    
    // MARK: Date/Time Section
    
    private func writeDateTimeSection(_ date: Date) {
        let formattedDateTime = "\(SectionEmojis.dateTime.rawValue) \(date)"
        self.output.write(formattedDateTime)
    }
    
    // MARK: Request Name Section
    
    private func writeRequestNameSection(_ requestName: String) {
        let formattedRequestName = "\(SectionEmojis.requestName.rawValue) Request Name: \(requestName)"
        self.output.write(formattedRequestName)
    }

    // MARK: Data Transfer Section
    
    private func writeDataTransferSection(for log: Log) {
        guard let formattedDataTransferSection = formattedDataTransferSectionFromLog(log) else {
            return
        }
        
        self.output.write(formattedDataTransferSection)
    }
    
    private func formattedDataTransferSectionFromLog(_ log: Log) -> String? {
        switch log.logType {
        case .request:
            return self.requestDataTransferSection(httpMethodType: log.httpMethodType, url: log.url)
        case .response:
            return self.responseDataTransferSection(url: log.url)
        }
    }
    
    private func requestDataTransferSection(httpMethodType: String?, url: String?) -> String? {
        guard let httpMethodType = httpMethodType else { return nil }
        guard let url = url else { return nil }

        return "\(SectionEmojis.sendingRequest.rawValue) Sending \(httpMethodType) to: \(url)"
    }
    
    private func responseDataTransferSection(url: String?) -> String? {
        guard let url = url else { return nil }

        return "\(SectionEmojis.receivingRequest.rawValue) Received from \(url)"
    }
    
    // MARK: Status Section
    
    private func writeStatusSection(for log: Log) {
        guard let formattedStatusSection = formattedStatusSectionFromLog(log) else {
            return
        }
        
        self.output.write(formattedStatusSection)
    }
    
    private func formattedStatusSectionFromLog(_ log: Log) -> String? {
        switch log.logType {
        case .request:
            return nil
        case .response:
            return self.responseStatusSection(status: log.status, statusDescription: log.statusDescription)
        }
    }
    
    private func responseStatusSection(status: Int?, statusDescription: String?) -> String? {
        guard let status = status else { return nil }
        guard let statusDescription = statusDescription else { return nil }
        
        let statusEmoji = status == 200 ? SectionEmojis.statusSuccess.rawValue : SectionEmojis.statusFailure.rawValue

        return "\(SectionEmojis.status.rawValue) Status: \(status) \(statusEmoji) -- \(statusDescription)"
    }
    
    // MARK: Headers Section
    
    private func writeHeadersSection(_ headers: [String: String]) {
        let formattedHeaders = "\(SectionEmojis.headers.rawValue) Headers: \(headers)"
        self.output.write(formattedHeaders)
    }
    
    // MARK: Body Section
    
    private func writeBodySection(_ body: String?) {
        let formattedBody = "\(SectionEmojis.body.rawValue) Body: None"
        self.output.write(formattedBody)
    }
}

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

// for prod/dev, can have different targets or a switch ...? By default, just use ifdebug.

