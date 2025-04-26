//
//  ContentView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(MoviesVM.self) private var vm
    @Query(filter: #Predicate { $0.nowPlaying },
           sort: [SortDescriptor<Movies>(\.title)]) var movies: [Movies]
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(movies) { movie in
                    VStack {
                        PosterView(movie: movie)
                        Text(vm.getGenres(movie: movie))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .safeAreaPadding()
    }
}

#Preview(traits: .sampleData) {
    ContentView()
        .environment(MoviesVM())
}
