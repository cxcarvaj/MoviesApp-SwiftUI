//
//  Repository.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import Foundation
import SMP25Kit

struct Repository: NetworkRepository {
    var decoder: JSONDecoder {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         formatter.locale = Locale(identifier: "en_US_POSIX")
         decoder.dateDecodingStrategy = .formatted(formatter)
         return decoder
     }
}

protocol NetworkRepository: NetworkInteractor, Sendable {
    func getGenres() async throws(NetworkError) -> [GenresDTO]
    
    func getNowPlayingMovies() async throws(NetworkError) -> [MovieDTO]
    
    func getUpcomingMovies() async throws(NetworkError) -> [MovieDTO]
}

extension NetworkRepository {
    
    func getGenres() async throws(NetworkError) -> [GenresDTO] {
        let headers: [String: String] = ["Bearer \(APIKey)":"Authorization"]
        return try await getJSON(.get(.genres, authorizedHeader: headers), type: GenresResponseDTO.self).genres
    }
    
    func getNowPlayingMovies() async throws(NetworkError) -> [MovieDTO] {
        let headers: [String: String] = ["Bearer \(APIKey)":"Authorization"]
        return try await getJSON(.get(.nowPlayingMovies, authorizedHeader: headers), type: MovieResponseDTO.self).results
    }
    
    func getUpcomingMovies() async throws(NetworkError) -> [MovieDTO] {
        let headers: [String: String] = ["Bearer \(APIKey)":"Authorization"]
        return try await getJSON(.get(.upcomingMovies, authorizedHeader: headers), type: MovieResponseDTO.self).results
    }
}
