//
//  TMDBResponseMocks.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation

struct TMDBResponseMocks {
}

extension TMDBResponseMocks {
    struct Genres {
    }
}

extension TMDBResponseMocks.Genres {
    struct getGenres {
    }
}

extension TMDBResponseMocks.Genres.getGenres {
    public static func successResponse() -> Data? {
        """
        {
          "genres": [
            {
              "id": 28,
              "name": "Action"
            }
          ]
        }
        """.data(using: .utf8)
    }
}
