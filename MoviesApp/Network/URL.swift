//
//  URL.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import Foundation

let apiBaseURL = URL(string: "https://api.themoviedb.org/3/")!

extension URL {
    static let movieApi = apiBaseURL.appending(path: "movie/")
    static let nowPlayingMovies = movieApi.appending(path: "now_playing").appending(queryItems: [.language, .region])
    static let upcomingMovies = movieApi.appending(path: "now_playing").appending(queryItems: [.language, .region])
    static let genres = apiBaseURL.appending(path: "genre/movie/list").appending(queryItems: [.language])
}

extension URLQueryItem {
    static let language = URLQueryItem(name: "language", value: "es-ES")
    static let region = URLQueryItem(name: "region", value: "ES")
}
