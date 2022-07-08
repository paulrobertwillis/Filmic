//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Paul on 06/07/2022.
//

import Foundation

protocol NetworkLoggerProtocol {
    func log(_ request: NetworkRequest)
    func log(_ response: NetworkResponse)
    func log(_ response: NetworkResponse, withError error: Error?)
}

class NetworkLogger {
    
    // MARK: - Public Properties
    
    var logs: [Log] = []
    
    // MARK: - Private Properties
    
    private let printer: NetworkLogPrinterProtocol
    
    // MARK: - Lifecycle
    
    init(printer: NetworkLogPrinterProtocol) {
        self.printer = printer
    }
}

// MARK: - NetworkLoggerProtocol

extension NetworkLogger: NetworkLoggerProtocol {
    func log(_ request: NetworkRequest) {
        let log = Log(logType: .request,
                      requestName: request.requestName,
                      httpMethodType: request.urlRequest.httpMethod,
                      url: request.urlRequest.url,
                      headers: request.urlRequest.allHTTPHeaderFields
        )
        
        self.logs.append(log)
        self.printer.printToDebugArea(log)
    }
    
    func log(_ response: NetworkResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: NetworkResponse, withError error: Error?) {
        let log = Log(logType: .response,
                      requestName: response.requestName,
                      url: response.urlResponse.url,
                      status: response.urlResponse.statusCode,
                      statusDescription: HTTPResponse.statusCodes[response.urlResponse.statusCode] ?? "",
                      headers: response.urlResponse.allHeaderFields as? [String: String],
                      errorDescription: error?.localizedDescription,
                      body: self.convertJsonToString(response.data)
        )
        
        self.logs.append(log)
    }
    
    private func convertJsonToString(_ data: Data?) -> String? {
        guard let data = data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}


struct HTTPResponse {
    public static let statusCodes: [Int: String] = [
        200: "OK",
        400: "Bad Request"
    ]
}

enum RequestName: String {
    case getMovieGenres
    case getTopRatedMovies
    case getPopularMovies
    case get
    case postMovieRating
    case deleteMovieRating
}

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

// MARK: - NetworkLogPrinter

protocol NetworkLogPrinterProtocol {
    func printToDebugArea(_ log: Log)
}

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
