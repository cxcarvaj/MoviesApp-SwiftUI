//
//  MoviesVM.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import SwiftUI

@Observable
final class MoviesVM {
    func getGenresString(movie: Movies) -> String {
        movie.moviesGenres?.map(\.genre).map(\.name).formatted(.list(type: .and)) ?? ""
    }
}
