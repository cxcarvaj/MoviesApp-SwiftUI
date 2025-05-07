//
//  MoviesVM.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import SwiftUI
import SwiftData

@Observable @MainActor
final class MoviesVM {
    // Solución < iOS 18
    var container: MoviesAppContainer?
    
    func getGenresString(movie: Movies) -> String {
        movie.moviesGenres?.map(\.genre).map(\.name).formatted(.list(type: .and)) ?? ""
    }
    
    func getDetails(forMovieId id: Int) async {
        do {
            try await container?.getDetails(forMovieId: id)
        } catch {
            print("Error getting details for movie \(id): \(error)")
        }
    }
}
