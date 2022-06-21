//
//  AppConfiguration.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

final class AppConfiguration {
    struct TMDBConfiguration {
        let apiKey: String = {
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB API Key") as? String else {
                fatalError("TMDB API Key must not be empty in plist")
            }
            return apiKey
        }()
        let baseURL: String = {
            guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "TMDB Base Url") as? String else {
                fatalError("TMDB Base Url must not be empty in plist")
            }
            return apiBaseURL
        }()
    }
}

extension AppConfiguration.TMDBConfiguration {
    struct ImageConfiguration {
        let baseUrl: String?
        let secureBaseUrl: String?
        let backdropSizes: [String]?
        let logoSizes: [String]?
        let posterSizes: [String]?
        let profileSizes: [String]?
        let stillSizes: [String]?
    }
}
