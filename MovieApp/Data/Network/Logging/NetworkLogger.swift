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
    var logs: [Log] = []
    var printedLog: String = ""
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
        self.printToDebugArea(log)
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
    
    private func printToDebugArea(_ log: Log) {
        self.printedLog.append(contentsOf: log.dateTime.description)
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