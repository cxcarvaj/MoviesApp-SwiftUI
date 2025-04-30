//
//  PosterView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import SwiftUI
import SMP25Kit

struct PosterView: View {
    @State private var imageVM = AsyncImageVM()
    let movie: Movies
    let namespace: Namespace.ID
    
    var body: some View {
        if let poster = imageVM.image {
            Image(uiImage: poster)
                .resizable()
                .scaledToFit()
//                .frame(width: 200, height: 300)
                .matchedTransitionSource(id: "poster\(movie.id)", in: namespace)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .frame(height: 50)
                        .overlay {
                           title
                        }
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .primary.opacity(0.3), radius: 5, x: 0, y: 5)
        } else {
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFit()
                .padding()
//                .frame(width: 200, height: 300)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .frame(height: 50)
                        .overlay {
                            title
                        }
                    
                }
                .background {
                    Color.gray.opacity(0.2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .matchedTransitionSource(id: "poster\(movie.id)", in: namespace)
                .onAppear {
                    imageVM.getImage(url: movie.poster)
                }
        }
    }
    
    var title: some View {
        Text(movie.title)
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .padding()
            .lineLimit(2, reservesSpace: true)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
    }
    
}

#Preview(traits: .sampleData) {
    @Previewable @Namespace var namespace
    PosterView(movie: .testMovie, namespace: namespace)
}
