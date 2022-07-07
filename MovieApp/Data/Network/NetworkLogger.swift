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

struct Log: Equatable {
    enum LogType {
        case request
        case response
    }
    
    let logType: LogType
    let dateTime: Date
    let requestName: String
    let httpMethodType: String?
    let url: String?
    let status: Int?
    let statusDescription: String?
    let headers: [String: String]?
    let errorDescription: String?
    let body: String?
    
    init(
        logType: LogType,
        requestName: RequestName,
        httpMethodType: String? = nil,
        url: URL?,
        status: Int? = nil,
        statusDescription: String? = nil,
        headers: [String: String]? = nil,
        errorDescription: String? = nil,
        body: String? = nil) {
            self.logType = logType
            self.requestName = requestName.rawValue
            self.httpMethodType = httpMethodType
            self.url = url?.absoluteString
            self.status = status
            self.statusDescription = statusDescription
            self.headers = headers
            self.dateTime = Date()
            self.errorDescription = errorDescription
            self.body = body
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
