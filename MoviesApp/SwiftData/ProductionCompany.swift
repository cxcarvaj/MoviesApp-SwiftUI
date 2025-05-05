//
//  ProductionCompany.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//


import Foundation
 import SwiftData
 
 @Model
 final class ProductionCompany {
     @Attribute(.unique) var id: Int
     var name: String
     var logoImage: URL?
     
     @Relationship(deleteRule: .cascade) var movies: [Movies]
     
     init(id: Int, name: String, logoImage: URL?) {
         self.id = id
         self.name = name
         self.logoImage = logoImage
         self.movies = []
     }
 }
 
 extension ProductionCompany {
     @MainActor static let testCompany = ProductionCompany(id: 420, name: "Marvel Studios", logoImage: URL(string: "https://image.tmdb.org/t/p/w185/hUzeosd33nzE5MCNsZxCGEKTXaQ.png"))
 }