//
//  NetworkLogger.swift
//  MovieApp
//
//  Created by Paul on 06/07/2022.
//

import Foundation

protocol NetworkLoggerProtocol {
//    func log(_ request: URLRequest)
    func log(_ response: HTTPURLResponse)
}

class NetworkLogger {
    var logs: [Log] = []
}


// MARK: - NetworkLoggerProtocol

extension NetworkLogger: NetworkLoggerProtocol {
    func log(_ request: URLRequest) {
        let log = Log(type: .request,
                      url: request.url
        )
        
        self.logs.append(log)
    }
    
    func log(_ response: HTTPURLResponse) {
        let log = Log(type: .response,
                            url: response.url,
                            status: response.statusCode,
                            statusDescription: HTTPResponseStatusCode.statusCodes[response.statusCode] ?? ""
        )
        
        self.logs.append(log)
    }
}

struct Log: Equatable {
    enum LogType {
        case request
        case response
    }
    
    let type: LogType
    let url: URL?
    let status: Int?
    let statusDescription: String?
    
    init(
        type: LogType,
        url: URL?,
        status: Int? = nil,
        statusDescription: String? = nil) {
            self.type = type
            self.url = url
            self.status = status
            self.statusDescription = statusDescription
        }
}

struct HTTPResponseStatusCode {
    public static let statusCodes: [Int: String] = [
        200: "OK",
        400: "Bad Request"
    ]
}
