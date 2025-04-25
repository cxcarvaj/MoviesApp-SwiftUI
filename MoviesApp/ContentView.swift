//
//  ContentView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: [SortDescriptor<Movies>(\.title)]) var movies: [Movies]
    
    var body: some View {
        List(movies) { movie in
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.genres.map(\.name).sorted().formatted(.list(type: .and)))
                    .font(.footnote)
                    .foregroundStyle(.secondary)

            }
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView()
}
