//
//  TMDBResponseMocks.swift
//  MovieAppTests
//
//  Created by Paul on 01/07/2022.
//

import Foundation

struct TMDBResponseMocks {
    struct Genres {
    }
    
    struct Movies {
    }
}

// MARK: - Account

// MARK: - Authentication

// MARK: - Certifications

// MARK: - Changes

// MARK: - Collections

// MARK: - Companies

// MARK: - Configuration

// MARK: - Credits

// MARK: - Discover

// MARK: - Find

// MARK: - Genres
extension TMDBResponseMocks.Genres {
    struct getGenres {
    }
}

extension TMDBResponseMocks.Genres.getGenres {
    public static func successResponse() -> Data {
        """
        {
          "genres": [
            {
              "id": 28,
              "name": "Action"
            }
          ]
        }
        """.data(using: .utf8)!
    }
}

// MARK: - Guest Sessions

// MARK: - Keywords

// MARK: - Lists

// MARK: - Movies
extension TMDBResponseMocks.Movies {
    struct getTopRated {
    }
}

extension TMDBResponseMocks.Movies.getTopRated {
    public static func successResponse() -> Data {
        """
        {
          "page": 1,
          "results": [
            {
              "poster_path": "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
              "adult": false,
              "overview": "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
              "release_date": "1994-09-10",
              "genre_ids": [
                18,
                80
              ],
              "id": 278,
              "original_title": "The Shawshank Redemption",
              "original_language": "en",
              "title": "The Shawshank Redemption",
              "backdrop_path": "/xBKGJQsAIeweesB79KC89FpBrVr.jpg",
              "popularity": 6.741296,
              "vote_count": 5238,
              "video": false,
              "vote_average": 8.32
            },
            {
              "poster_path": "/lIv1QinFqz4dlp5U4lQ6HaiskOZ.jpg",
              "adult": false,
              "overview": "Under the direction of a ruthless instructor, a talented young drummer begins to pursue perfection at any cost, even his humanity.",
              "release_date": "2014-10-10",
              "genre_ids": [
              18,
              10402
              ],
              "id": 244786,
              "original_title": "Whiplash",
              "original_language": "en",
              "title": "Whiplash",
              "backdrop_path": "/6bbZ6XyvgfjhQwbplnUh1LSj1ky.jpg",
              "popularity": 10.776056,
              "vote_count": 2059,
              "video": false,
              "vote_average": 8.29
            }
          ]
          "total_results": 5206,
          "total_pages": 261
        }
        """.data(using: .utf8)!
    }
}

// MARK: - Networks

// MARK: - People

// MARK: - Reviews

// MARK: - Search

// MARK: - TV

// MARK: - TV Seasons

// MARK: - TV Episodes

// MARK: - TV Episode Groups

// MARK: - Watch Providers
