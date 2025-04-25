//
//  GenresDTO.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import Foundation

struct GenresDTO: Codable {
    let id: Int
    let name: String
}

struct GenresResponseDTO: Codable {
    let genres: [GenresDTO]
}
