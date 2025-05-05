//
//  URL.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import Foundation

let apiBaseURL = URL(string: "https://api.themoviedb.org/3/")!

extension URL {
    static func movieApi(id: Int) -> URL {
        apiBaseURL.appending(path: "movie/\(id)").appending(queryItems: [.language, .appendCredits])
    }
    static let nowPlayingMovies = apiBaseURL.appending(path: "movie/now_playing").appending(queryItems: [.language, .region])
    static let upcomingMovies = apiBaseURL.appending(path: "movie/upcoming").appending(queryItems: [.language, .region])
    static let genres = apiBaseURL.appending(path: "genre/movie/list").appending(queryItems: [.language])
}

extension URLQueryItem {
    static let language = URLQueryItem(name: "language", value: "es-ES")
    static let region = URLQueryItem(name: "region", value: "ES")
    static let appendCredits = URLQueryItem(name: "append_to_response", value: "credits")
}
