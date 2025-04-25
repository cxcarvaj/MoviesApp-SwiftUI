//
//  Genres.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//
import Foundation
import SwiftData

@Model
final class Genres {
    @Attribute(.unique) var id: Int
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \Movies.genres) var movies: [Movies]
    
    init(id: Int, name: String, movies: [Movies] = []) {
        // Como yo voy a permitir crear un género sin peliculas, lo inicializo con un array vacio.
        // Si yo no quiero permitir eso, entonces le quito el valor opcional
        self.id = id
        self.name = name
        self.movies = movies
    }
}
