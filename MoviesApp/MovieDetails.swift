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
            VStack(spacing: 5) {
                VStack {
                     Text(movie.title)
                         .font(.headline)
                     Text(movie.originalTitle)
                         .font(.footnote)
                         .italic()
                 }
                 .padding(.bottom)
                
                if let tagline = movie.moviesDetails?.tagline {
                    Text(tagline)
                        .font(.caption)
                        .bold()
                }
                
                Text(movie.overview)
                     .font(.caption)
                     .padding(.vertical)
                
                 HStack {
                     Text("Release date: \(movie.releaseDate.formatted(date: .abbreviated, time: .omitted))")
                     Spacer()
                     Text("Original language: \(movie.originalLanguage)")
                 }
                 .font(.caption2)
                
                if let details = movie.moviesDetails {
                    HStack {
                        if details.budget != 0 {
                            Text("Budget: \((details.budget / 10_000_00))M USD")
                            Spacer()
                            if details.revenue != 0 {
                                Text("Revenue: \((details.revenue / 10_000_00))M USD")
                            }
                        }
                    }
                    .font(.footnote)
                    HStack {
                        if let imdb = details.imdbID,
                           let url = URL(string: "https://www.imdb.com/title/\(imdb)") {
                            Link(destination: url) {
                                Image(.imdb)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80)
                            }
                        }
                        Spacer()
                        if let homepage = details.homepage {
                            Link(destination: homepage) {
                                VStack {
                                    Image(systemName: "network")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                    
                                    Text("Homepage")
                                        .font(.caption)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 0) {
                         Text("Movie cast")
                             .font(.headline)
                         CastCrewView(movie: movie, selection: .cast)
                             .padding(.bottom, 10)
                         Text("Movie crew")
                             .font(.headline)
                         CastCrewView(movie: movie, selection: .crew)
                     }
                    
                    if let productionCompany = movie.productionCompany {
                        ProductionCompaniesView(productionCompanies: productionCompany)
                    }
                }
            }
            .safeAreaPadding(.horizontal)
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
