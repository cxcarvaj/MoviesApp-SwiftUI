//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by Carlos Xavier Carvajal Villegas on 29/4/25.
//

import Foundation
import Testing
import SwiftData
@testable import MoviesApp

@Suite("Loading data from the Database test")
struct MoviesAppDataTests {
    let movieAppContainer: MoviesAppContainer
    
    init() async throws {
        let configuration = ModelConfiguration(for: Movies.self, isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Movies.self, configurations: configuration)
        movieAppContainer = MoviesAppContainer(modelContainer: container)
        await movieAppContainer.setRepository(RepositoryTest())
        try await movieAppContainer.initialize()
    }
    
    
    @Test("Fetch all genres")
    func fetchGenresTest() throws {
        // el `movieAppContext` se habia puesto en el init, pero se movió a la función porque se rompia la app.
        // Ojo que aqui no estamos probando que cargue de la red.
        // Aqui estamos cargando que los datos que "vienen de la red" se estén cargando através del model actor.
//        let movieAppContext = ModelContext(movieAppContainer.modelContainer)
//        let genresFetch = FetchDescriptor<Genres>()
//        let genres = try movieAppContext.fetch(genresFetch)
        let genres = try fetch(Genres.self)
        
        #expect(genres.count > 0)
        #expect(genres.count == 19)
    }
    
    @Test("Fetch now playing movies")
    func fetchNowPlayingMoviesTest() async throws {
        let nowPlayingMovies = try fetch(Movies.self, predicate: #Predicate { $0.nowPlaying })
        #expect(nowPlayingMovies.count > 0)
        #expect(nowPlayingMovies.count == 20)
    }
    
    @Test("Fetch upcoming movies")
    func fetchUpcomingMoviesTest() async throws {
        let upComingMovies = try fetch(Movies.self, predicate: #Predicate { $0.upcoming })
        #expect(upComingMovies.count > 0)
        #expect(upComingMovies.count == 20)
    }
    
    @Test("Transform all genders into a String")
    func transformGendersToStringTest() throws {
        let vm = MoviesVM()
        let movies = try fetch(Movies.self)
        let movie = try #require(movies.first)
        let genresString = vm.getGenresString(movie: movie)
        let genresNames = try #require(movie.moviesGenres?.map(\.genre).map(\.name).formatted(.list(type: .and)))
        #expect(genresString.isEmpty == false)
        #expect(genresString == genresNames)
    }
    
    func fetch<T>(_ model: T.Type, predicate: Predicate<T>? = nil) throws -> [T] where T: PersistentModel {
        let movieAppContext = ModelContext(movieAppContainer.modelContainer)
        var fetchDescriptor = FetchDescriptor<T>()
        if let predicate {
            fetchDescriptor.predicate = predicate
        }
        return try movieAppContext.fetch(fetchDescriptor)
    }
}

// Esta extensión, solamente va a vivir dentro de los tests
extension MoviesAppContainer {
    func setRepository(_ repository: NetworkRepository) {
        self.repository = repository
    }
}
