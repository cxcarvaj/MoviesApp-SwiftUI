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
    
    
    func getDetails(forMovieId: Int) async throws {
        let detail = try await repository.getDetails(forMovieId: forMovieId)
        guard let movie = try fetch(Movies.self, predicate: #Predicate { $0.id == forMovieId }).first else { return }
    
        if let details = movie.moviesDetails {
            updateMovieDetails(detail: details, detailDTO: detail)
        } else {
            try insertMoviesDetails(movie: movie, detail: detail)
        }
        try insertCastCrew(movie: movie, detail: detail)
        
        // Con esto cargo toda la table, pero solo el id. Sino quiero cargar toda la tabla porque puede ser pequeña, puedo usar el approach de llamar en cada vuelta el fetch.
        var fetch = FetchDescriptor<ProductionCompany>()
        fetch.propertiesToFetch = [\.id]
        let existingProductionCompanies = try modelContext.fetch(fetch).reduce(into: [Int : ProductionCompany]()) { $0[$1.id] = $1 }
        
        for productionCompany in detail.productionCompanies {
//            let id = productionCompany.id
//            if let company = try fetchSingle(ProductionCompany.self, predicate: #Predicate { $0.id == id }){
            if let company = existingProductionCompanies[productionCompany.id] {
                company.name = productionCompany.name ?? ""
                company.logoImage = URL(string: "https://image.tmdb.org/t/p/w185/\(productionCompany.logoPath ?? "")")
            } else {
                let newCompany = ProductionCompany(id: productionCompany.id,
                                                   name: productionCompany.name ?? "",
                                                   logoImage: URL(string: "https://image.tmdb.org/t/p/w185/\(productionCompany.logoPath ?? "")"))
                modelContext.insert(newCompany)
                movie.productionCompany?.append(newCompany)
            }
        }
        // Refresca la UI
        try modelContext.save()
    }
    
    func insertMoviesDetails(movie: Movies, detail: MovieDetailsDTO) throws {
        let movieDetails = MoviesDetails(budget: detail.budget,
                                         homepage: URL(string: detail.homepage ?? ""),
                                         imdbID: detail.imdbID,
                                         revenue: detail.revenue,
                                         runtime: detail.runtime,
                                         status: detail.status,
                                         tagline: detail.tagline ?? "")
        modelContext.insert(movieDetails)
        movie.moviesDetails = movieDetails
    }
    
    func updateMovieDetails(detail: MoviesDetails, detailDTO: MovieDetailsDTO) {
        detail.budget = detailDTO.budget
        if let homepage = detailDTO.homepage {
            detail.homepage = URL(string: homepage)
        }
        detail.imdbID = detailDTO.imdbID
        detail.revenue = detailDTO.revenue
        detail.runtime = detailDTO.runtime
        detail.status = detailDTO.status
        if let tagline = detailDTO.tagline {
            detail.tagline = tagline
        }
    }
    
    func insertCastCrew(movie: Movies, detail: MovieDetailsDTO) throws {
        if let castList = detail.credits.cast {
            for cast in castList {
                let id = cast.id
                if let person = try fetchSingle(Person.self, predicate: #Predicate { $0.id == id }) {
                    person.name = cast.name
                    person.profileImage = getURLImage(path: cast.profilePath)
                    person.gender = cast.gender == 1 ? .female : .male

                    let newCast = Cast(character: cast.character ?? "",
                                       order: cast.order ?? 0,
                                       person: person)
                    newCast.movies.append(movie)
                    modelContext.insert(newCast)
                } else {
                    let newPerson = Person(id: id,
                                           name: cast.name,
                                           gender: cast.gender == 1 ? .female : .male,
                                           profileImage: getURLImage(path: cast.profilePath))
                    modelContext.insert(newPerson)
                    
                    let newCast = Cast(character: cast.character ?? "",
                                       order: cast.order ?? 0,
                                       person: newPerson)
                    newCast.movies.append(movie)
                    modelContext.insert(newCast)
                }
            }
        }
        
        if let crewList = detail.credits.crew {
            for crew in crewList {
                let id = crew.id
                if let person = try fetchSingle(Person.self, predicate: #Predicate { $0.id == id }) {
                    person.name = crew.name
                    person.gender = crew.gender == 1 ? .female : .male
                    person.profileImage = getURLImage(path: crew.profilePath)
                    
                    let newCrew = Crew(department: crew.department ?? "",
                                       job: crew.job ?? "",
                                       person: person)
                    newCrew.movies.append(movie)
                    modelContext.insert(newCrew)
                } else {
                    let newPerson = Person(id: id,
                                           name: crew.name,
                                           gender: crew.gender == 1 ? .female : .male,
                                           profileImage: getURLImage(path: crew.profilePath))
                    modelContext.insert(newPerson)
                    
                    let newCrew = Crew(department: crew.department ?? "",
                                       job: crew.job ?? "",
                                       person: newPerson)
                    newCrew.movies.append(movie)
                    modelContext.insert(newCrew)
                }
            }
        }
    }
    
    func getURLImage(path: String?) -> URL? {
        return if let path, let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            url
        } else {
            nil
        }
    }
    
    func fetchGenresByIds(_ ids: [Int]) throws -> [Genres] {
        let descriptor = FetchDescriptor<Genres>(predicate: #Predicate {
            ids.contains($0.id)
        })
        return try modelContext.fetch(descriptor)
    }
    
    func fetch<T>(_ model: T.Type, predicate: Predicate<T>? = nil) throws -> [T] where T: PersistentModel {
        var fetchDescriptor = FetchDescriptor<T>()
        if let predicate {
            fetchDescriptor.predicate = predicate
        }
        return try modelContext.fetch(fetchDescriptor)
    }
    
    func fetchSingle<T>(_ model: T.Type, predicate: Predicate<T>? = nil) throws -> T? where T: PersistentModel {
        var fetchDescriptor = FetchDescriptor<T>()
        fetchDescriptor.fetchLimit = 1
        if let predicate {
            fetchDescriptor.predicate = predicate
        }
        return try modelContext.fetch(fetchDescriptor).first
    }

}
