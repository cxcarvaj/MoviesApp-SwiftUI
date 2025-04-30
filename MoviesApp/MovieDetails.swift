//
//  MovieDetails.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//

import SwiftUI

struct MovieDetails: View {
    @Environment(\.dismiss) private var dismiss
    let movie: Movies
    
    var body: some View {
        ScrollView {
            PosterInsideView(movie: movie)

            VStack {
                 Text(movie.title)
                     .font(.headline)
                 Text(movie.originalTitle)
                     .font(.footnote)
                     .italic()
             }
             .padding(.bottom)
            
            Text(movie.overview)
                 .font(.caption)
             HStack {
                 Text("Release date: \(movie.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                 Spacer()
                 Text("Original language: \(movie.originalLanguage)")
             }
             .padding()
             .font(.caption2)
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden()
//        .overlay(alignment: .topTrailing) {
//            Button {
//                dismiss()
//            } label: {
//                Image(systemName: "xmark")
//                    .symbolVariant(.circle.fill)
//                    
//            }
//            .buttonBorderShape(.circle)
//            .hoverEffect(.highlight)
//            .font(.title)
//            .buttonStyle(.plain)
//            .foregroundStyle(.white.opacity(0.5))
////            .opacity(0.5) -> Esto hacia que no se haga click
//            .padding(.trailing)
//
//        }
        .circleCloseButton {
            dismiss()
        }
    }
}

#Preview(traits: .sampleData) {
    MovieDetails(movie: .testMovie)
}
