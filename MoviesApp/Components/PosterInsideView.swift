//
//  PosterInsideView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 25/4/25.
//

import SwiftUI
import SMP25Kit

struct PosterInsideView: View {
    @State private var imageVM = AsyncImageVM()
    let movie: Movies
    
    var body: some View {
        if let poster = imageVM.image {
            Image(uiImage: poster)
                .resizable()
                .scaledToFill()
                .frame(maxHeight: 350, alignment: .center)
                .clipped()

        } else {
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFill()
                .padding(100)
                .frame(maxHeight: 350, alignment: .center)
                .clipped()
                .background {
                    Color.gray.opacity(0.2)
                }
                .onAppear {
                    imageVM.getImage(url: movie.poster)
                }
        }
    }
}

#Preview(traits: .sampleData) {
    PosterInsideView(movie: .testMovie)
}
