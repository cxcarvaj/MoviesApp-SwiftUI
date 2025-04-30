//
//  ContentView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import SwiftUI
import SwiftData

enum MovieType: String, CaseIterable, Identifiable {
    var id: Self { self }
    case nowPlaying = "Now Playing"
    case upcoming = "Upcoming"
}

struct ContentView: View {
    @State private var selectedMovieType: MovieType = .nowPlaying
    @Namespace private var namespace
    
    var body: some View {
       NavigationStack {
           VStack {
               Picker(selection: $selectedMovieType) {
                   ForEach(MovieType.allCases) { movieType in
                       Text(movieType.rawValue)
                           .tag(movieType)
                   }
               } label: {
                   Text("Movie Type List")
               }
               .pickerStyle(.segmented)
    //            ScrollView {
    //                switch selectedMovieType {
    //                case .nowPlaying:
    //                    MoviesView(predicate: #Predicate { $0.nowPlaying })
    //                case .upcoming:
    //                    MoviesView(predicate: #Predicate { $0.upcoming })
    //                }
    //
    //            }
               // Pantallas con Opacity 0, no consumen bateria
               ZStack {
                   MoviesView(predicate: #Predicate { $0.nowPlaying }, namespace: namespace)
                       .opacity( selectedMovieType == .nowPlaying ? 1 : 0)
                       .offset(x: selectedMovieType == .upcoming ? -300 : 0)
                   MoviesView(predicate: #Predicate { $0.upcoming }, namespace: namespace)
                       .opacity( selectedMovieType == .upcoming ? 1 : 0)
                       .offset(x: selectedMovieType == .nowPlaying ? 300 : 0)
               }
            }
           .safeAreaPadding()
           .animation(.bouncy, value: selectedMovieType)
           .navigationDestination(for: Movies.self) { movie in
               MovieDetails(movie: movie)
                   .navigationTransition(.zoom(sourceID: "poster\(movie.id)", in: namespace))
           }
       }
    }


}

#Preview(traits: .sampleData) {
    ContentView()
        .environment(MoviesVM())
}
