//
//  MoviesAppPreviewContainer.swift.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import SwiftUI
import SwiftData

@MainActor
final class MoviesAppPreviewContainer: Sendable {
    
    static let movieDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    let decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(movieDateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var urlGenres: URL {
        Bundle.main.url(forResource: "genres", withExtension: "json")!
    }
    
    var urlNowPlayingMovies: URL {
        Bundle.main.url(forResource: "now_playing", withExtension: "json")!
    }
    
    var urlUpcomingMovies: URL {
        Bundle.main.url(forResource: "upcoming", withExtension: "json")!
    }
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func loadGenres() throws {
        let data = try Data(contentsOf: urlGenres)
        let genresDTO = try decoder.decode(GenresResponseDTO.self, from: data).genres
//        genresDTO.forEach {
//            let genre = Genres(id: $0.id, name: $0.name)
//            context.insert(genre)
//        }
        genresDTO.map {
            Genres(id: $0.id, name: $0.name)
        }.forEach {
            context.insert($0)
        }
    }
    
    func loadMovies() throws {
        let data = try Data(contentsOf: urlNowPlayingMovies)
        let moviesDTO = try decoder.decode(MovieResponseDTO.self, from: data).results
//        moviesDTO.forEach {
//            let movie = Movies(id: $0.id,
//                               title: $0.title,
//                               originalTitle: $0.originalTitle,
//                               originalLanguage: $0.originalLanguage,
//                               overview: $0.overview,
//                               releaseDate: $0.releaseDate,
//                               voteAverage: $0.voteAverage,
//                               genres: [])
//            context.insert(movie)
//        }
        try moviesDTO.forEach { movie in
            let newMovie = Movies(id: movie.id,
                                  title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  originalLanguage: movie.originalLanguage,
                                  overview: movie.overview,
                                  releaseDate: movie.releaseDate,
                                  poster: movie.posterPath,
                                  backdrop: movie.backdropPath,
                                  voteAverage: movie.voteAverage)
            context.insert(newMovie)
            
            try fetchGenresByIds(movie.genreIds).forEach { genre in
                let moviesGenres = MoviesGenres(movie: newMovie, genre: genre)
                context.insert(moviesGenres)
            }
        }
    }
    
    func fetchGenresByIds(_ ids: [Int]) throws -> [Genres] {
        // El FetchDescriptor<Genres>() es un Select * from Genres
        // Con el predicate estamos haciendo una condicion (where)
        let descriptor = FetchDescriptor<Genres>(predicate: #Predicate {
            ids.contains($0.id)
        })
        return try context.fetch(descriptor)
    }
}
