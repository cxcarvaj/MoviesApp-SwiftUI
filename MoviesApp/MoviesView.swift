//
//  MoviesView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 29/4/25.
//

import SwiftUI
import SwiftData

struct MoviesView: View {
    @Query private var movies: [Movies]
    private let columns = [GridItem(.adaptive(minimum: 150))]
    let namespace: Namespace.ID
    
    init(predicate: Predicate<Movies>, namespace: Namespace.ID) {
        self.namespace = namespace
        _movies = Query(filter: predicate, sort: [SortDescriptor<Movies>(\.title)], animation: .default)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(movies) { movie in
                    NavigationLink(value: movie) {
                        PosterView(movie: movie, namespace: namespace)
                    }
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Namespace var namespace
    MoviesView(predicate: #Predicate<Movies> { $0.nowPlaying }, namespace: namespace)
}
