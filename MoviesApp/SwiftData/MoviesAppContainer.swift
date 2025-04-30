//
//  MoviesAppContainer.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import Foundation
import SwiftData

// Este actor se va a encargar de la carga de los datos.
@ModelActor
actor MoviesAppContainer {
    var repository: NetworkRepository = Repository()
    
    func initialize() async throws {
        let genresDTO = try await repository.getGenres()
        try loadGenres(genresDTO: genresDTO)
        
        let (nowPlayingMoviesDTO, upcomingMoviesDTO) = try await (repository.getNowPlayingMovies(), repository.getUpcomingMovies())
        
        let nowPlayingMovies = try loadMovies(moviesDTO: nowPlayingMoviesDTO)
        print("nowPlayingMovies: \(nowPlayingMovies)")
        nowPlayingMovies.forEach { $0.nowPlaying = true }
        let upcomingMovies = try loadMovies(moviesDTO: upcomingMoviesDTO)
        upcomingMovies.forEach { $0.upcoming = true }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }

    }
    
    func loadGenres(genresDTO: [GenresDTO]) throws {
        genresDTO.map {
            Genres(id: $0.id, name: $0.name)
        }.forEach {
            modelContext.insert($0)
        }
    }
    
    func loadMovies(moviesDTO: [MovieDTO]) throws -> [Movies] {
        // Array para almacenar los resultados
        var results = [Movies]()
        
        // Procesar cada película secuencialmente dentro del actor
        for movie in moviesDTO {
            // Crear la película
            let newMovie = Movies(id: movie.id,
                                  title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  originalLanguage: movie.originalLanguage,
                                  overview: movie.overview,
                                  releaseDate: movie.releaseDate,
                                  poster: movie.posterPath,
                                  backdrop: movie.backdropPath,
                                  voteAverage: movie.voteAverage)
            
            modelContext.insert(newMovie)
            
            // Obtener y vincular los géneros
            let genres = try fetchGenresByIds(movie.genreIds)
            for genre in genres {
                let moviesGenres = MoviesGenres(movie: newMovie, genre: genre)
                modelContext.insert(moviesGenres)
            }
            
            results.append(newMovie)
        }
        
        return results
    }
    
    func fetchGenresByIds(_ ids: [Int]) throws -> [Genres] {
        let descriptor = FetchDescriptor<Genres>(predicate: #Predicate {
            ids.contains($0.id)
        })
        return try modelContext.fetch(descriptor)
    }
    
}
