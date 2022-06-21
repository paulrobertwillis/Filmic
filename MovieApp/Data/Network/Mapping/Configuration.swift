//
//  Configuration.swift
//  MovieApp
//
//  Created by Paul on 21/06/2022.
//

import Foundation

struct TMDBConfigurationResponseDTO: Decodable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
    let images: ImageConfigurationDTO?
    let changeKeys: [String]?
}

extension TMDBConfigurationResponseDTO {
    struct ImageConfigurationDTO: Decodable, Equatable {
        private enum CodingKeys: String, CodingKey {
            case baseUrl = "base_url"
            case secureBaseUrl = "secure_base_url"
            case backdropSizes = "backdrop_sizes"
            case logoSizes = "logo_sizes"
            case posterSizes = "poster_sizes"
            case profileSizes = "profile_sizes"
            case stillSizes = "still_sizes"
        }
        let baseUrl: String?
        let secureBaseUrl: String?
        let backdropSizes: [String]?
        let logoSizes: [String]?
        let posterSizes: [String]?
        let profileSizes: [String]?
        let stillSizes: [String]?
    }
}

extension TMDBConfigurationResponseDTO.ImageConfigurationDTO {
    func toApplication() -> AppConfiguration.TMDBConfiguration.ImageConfiguration {
        return .init(
            baseUrl: self.baseUrl,
            secureBaseUrl: self.secureBaseUrl,
            backdropSizes: self.backdropSizes,
            logoSizes: self.logoSizes,
            posterSizes: self.posterSizes,
            profileSizes: self.profileSizes,
            stillSizes: self.stillSizes
        )
    }
}
