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
    // Como los id's de los géneros son un array
    // Significa que tendré más de un género por cada movie.
    // Por eso la relación que se debe crear, debe ser n:n
    @Relationship(deleteRule: .deny) var genres: [Genres]
    
    init(id: Int, title: String, originalTitle: String, originalLanguage: String, overview: String, releaseDate: Date, poster: URL? = nil, backdrop: URL? = nil, voteAverage: Double, genres: [Genres] = []) {
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
        self.genres = genres
    }
}
