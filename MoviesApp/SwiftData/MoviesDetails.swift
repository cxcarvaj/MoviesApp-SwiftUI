//
//  MoviesDetails.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//

import Foundation
import SwiftData

@Model
 final class MoviesDetails {
     @Attribute(.unique) var id: UUID
     var budget: Int
     var homepage: URL?
     var imdbID: String?
     var revenue: Int
     var runtime: Int
     var status: String
     var tagline: String?
     
     @Relationship(deleteRule: .cascade, inverse: \Movies.moviesDetails) var movie: Movies?
     
     init(id: UUID = UUID(), budget: Int, homepage: URL?, imdbID: String?, revenue: Int, runtime: Int, status: String, tagline: String) {
         self.id = id
         self.budget = budget
         self.homepage = homepage
         self.imdbID = imdbID
         self.revenue = revenue
         self.runtime = runtime
         self.status = status
         self.tagline = tagline
     }
 }
 
 extension MoviesDetails {
     @MainActor static let detailsTest = MoviesDetails(budget: 180_000_000,
                                                       homepage: URL(string: "https://www.marvel.com/movies/thunderbolts"),
                                                       imdbID: "tt20969586",
                                                       revenue: 850000000,
                                                       runtime: 127,
                                                       status: "Released",
                                                       tagline: "Everyone deserves a second shot.")
 }
