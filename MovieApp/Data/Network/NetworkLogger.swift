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
                      errorDescription: error?.localizedDescription
        )
                
        self.logs.append(log)
    }
}

struct Log: Equatable {
    enum LogType {
        case request
        case response
    }
    
    let logType: LogType
    let timeDate: Date
    let requestName: RequestName
    let httpMethodType: String?
    let url: URL?
    let status: Int?
    let statusDescription: String?
    let headers: [String: String]?
    let errorDescription: String?
    
    init(
        logType: LogType,
        requestName: RequestName,
        httpMethodType: String? = nil,
        url: URL?,
        status: Int? = nil,
        statusDescription: String? = nil,
        headers: [String: String]? = nil,
        errorDescription: String? = nil) {
            self.logType = logType
            self.requestName = requestName
            self.httpMethodType = httpMethodType
            self.url = url
            self.status = status
            self.statusDescription = statusDescription
            self.headers = headers
            self.timeDate = Date()
            self.errorDescription = errorDescription
        }
}

struct HTTPResponse {
    public static let statusCodes: [Int: String] = [
        200: "OK",
        400: "Bad Request"
    ]
}

protocol RequestNameProtocol {}

enum RequestName: String, RequestNameProtocol {
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
