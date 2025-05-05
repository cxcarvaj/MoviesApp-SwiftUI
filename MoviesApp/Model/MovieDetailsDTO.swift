//
//  MovieDetailsDTO.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//


import Foundation
 
 struct MovieDetailsDTO: Codable {
     let id: Int
     let budget: Int
     let homepage: String?
     let imdbID: String?
     let productionCompanies: [ProductionCompanyDTO]
     let revenue: Int
     let runtime: Int
     let status: String
     let tagline: String?
     let video: Bool
     let credits: CreditsDTO
 }
 
 struct ProductionCompanyDTO: Codable {
     let id: Int
     let logoPath: String?
     let name: String?
 }
 
 struct CreditsDTO: Codable {
     let cast: [CastCrewDTO]?
     let crew: [CastCrewDTO]?
 }
 
 struct CastCrewDTO: Codable {
     let id: Int
     let gender: Int?
     let name: String
     let profilePath: String?
     let character: String?
     let order: Int?
     let department: String?
     let job: String?
 }
