//
//  Log.swift
//  MovieApp
//
//  Created by Paul on 08/07/2022.
//

import Foundation

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
