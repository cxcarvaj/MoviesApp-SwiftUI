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
    @Relationship(deleteRule: .cascade, inverse: \MoviesGenres.genre) var moviesGenres: [MoviesGenres]?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class MoviesGenres {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var movie: Movies
    @Relationship(deleteRule: .cascade) var genre: Genres
    
    init(id: UUID = UUID(), movie: Movies, genre: Genres) {
        self.id = id
        self.movie = movie
        self.genre = genre
    }
    
}
