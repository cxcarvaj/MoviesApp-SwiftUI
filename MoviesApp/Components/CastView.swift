//
//  CastView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 5/5/25.
//

import SwiftData
import SwiftUI

func castSorted(cast: [Cast]) -> [Cast] {
     cast.sorted { c1, c2 in
         c1.order < c2.order
     }
 }

struct CastView: View {
    let movie: Movies

    var body: some View {
        ScrollView(.horizontal) {
            if let cast = movie.cast {
                LazyHStack {
                    ForEach(Array(castSorted(cast: cast).enumerated()), id: \.element.id) { index, cc in
                        CastCrewImage(
                            name: cc.person.name,
                            detail: cc.character,
                            url: cc.person.profileImage
                        ).padding(.horizontal, index == 0 ? 0 : 10)

                    }
                }
                .frame(height: 250)
            }
        }
    }
}

struct CrewView: View {
    let movie: Movies

    var body: some View {
        ScrollView(.horizontal) {
            if let crew = movie.crew {
                LazyHStack {
                    ForEach(Array(crew.enumerated()), id: \.element.id) { index, cc in
                        CastCrewImage(
                            name: cc.person.name,
                            detail: cc.job,
                            url: cc.person.profileImage
                        ).padding(.horizontal, index == 0 ? 0 : 10)

                    }
                }
                .frame(height: 250)
            }
        }
    }
}

#Preview("CastView", traits: .sampleData) {
    CastView(movie: .testMovie)
}

#Preview("CrewView", traits: .sampleData) {
    CrewView(movie: .testMovie)
}
