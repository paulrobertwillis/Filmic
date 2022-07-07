//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Paul on 06/07/2022.
//

import Foundation

protocol NetworkLoggerProtocol {
    func log(_ request: URLRequest)
    func log(_ response: HTTPURLResponse)
    func log(_ response: HTTPURLResponse, withError error: Error?)
}

class NetworkLogger {
    var logs: [Log] = []
}


// MARK: - NetworkLoggerProtocol

extension NetworkLogger: NetworkLoggerProtocol {
    func log(_ request: URLRequest) {
        let log = Log(type: .request,
                      url: request.url,
                      headers: request.allHTTPHeaderFields
        )
        
        self.logs.append(log)
    }
    
    func log(_ response: HTTPURLResponse) {
        self.log(response, withError: nil)
    }
    
    func log(_ response: HTTPURLResponse, withError error: Error?) {
        let log = Log(type: .response,
                      url: response.url,
                      status: response.statusCode,
                      statusDescription: HTTPResponse.statusCodes[response.statusCode] ?? "",
                      headers: response.allHeaderFields as? [String: String],
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
    
    let timeDate: Date
    let type: LogType
    let url: URL?
    let status: Int?
    let statusDescription: String?
    let headers: [String: String]?
    let errorDescription: String?
    
    init(
        type: LogType,
        url: URL?,
        status: Int? = nil,
        statusDescription: String? = nil,
        headers: [String: String]? = nil,
        errorDescription: String? = nil) {
            self.type = type
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
