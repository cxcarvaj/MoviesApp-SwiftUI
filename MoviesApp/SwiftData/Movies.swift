//
//  Movies.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import Foundation
import SwiftData

@Model
final class Movies {
    @Attribute(.unique) var id: Int
    var title: String
    var originalTitle: String
    var originalLanguage: String
    var overview: String
    var releaseDate: Date
    var poster: URL?
    var backdrop: URL?
    var voteAverage: Double
    var nowPlaying: Bool = false
    var upcoming: Bool = false
    // Como los id's de los géneros son un array
    // Significa que tendré más de un género por cada movie.
    // Por eso la relación que se debe crear, debe ser n:n
//    @Relationship(deleteRule: .deny) var genres: [Genres]
    @Relationship(deleteRule: .cascade, inverse: \MoviesGenres.movie) var moviesGenres: [MoviesGenres]?
    @Relationship(deleteRule: .cascade) var moviesDetails: MoviesDetails?
    @Relationship(deleteRule: .cascade, inverse: \CastCrew.movies) var castCrew: [CastCrew]?
    @Relationship(deleteRule: .cascade, inverse: \ProductionCompany.movies) var productionCompany: [ProductionCompany]?
    
    init(id: Int, title: String, originalTitle: String, originalLanguage: String, overview: String, releaseDate: Date, poster: URL?, backdrop: URL?, voteAverage: Double) {
        // Como yo voy a permitir generar una pelicula sin género, lo inicializo con un array vacio.
        // Si yo no quiero permitir eso, entonces le quito el valor opcional
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.releaseDate = releaseDate
        self.poster = poster
        self.backdrop = backdrop
        self.voteAverage = voteAverage
    }
}

extension Movies {
    // Registro de pelicula como un valor automatico de clousure
     @MainActor static let testMovie: Movies = {
         let genre = Genres(id: 12, name: "Aventura")
         let movie = Movies(id: 986056,
                            title: "Thunderbolts*",
                            originalTitle: "Thunderbolts*",
                            originalLanguage: "en",
                            overview: "Un grupo de supervillanos y antihéroes van en misiones para el gobierno. Basado en la serie de cómics del mismo nombre.",
                            releaseDate: .now,
                            poster: URL(string: "https://image.tmdb.org/t/p/w500/eA39qgcH3r2dA9MQMBPwEXS6F86.jpg"),
                            backdrop: nil,
                            voteAverage: 7)
         
         let moviesGenres = MoviesGenres(movie: movie, genre: genre)
         movie.moviesGenres?.append(moviesGenres)
         movie.moviesDetails = .detailsTest
         let testProduction = ProductionCompany.testCompany
         testProduction.movies.append(movie)
         let (testCast1, testCast2, testCrew1, testCrew2) = (CastCrew.testCast1, CastCrew.testCast2, CastCrew.testCrew1, CastCrew.testCrew2)
         testCast1.movies.append(movie)
         testCast2.movies.append(movie)
         testCrew1.movies.append(movie)
         testCrew2.movies.append(movie)
         return movie
     }()
 }
