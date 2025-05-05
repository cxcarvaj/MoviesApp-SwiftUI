//
//  CastCrewView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 1/5/25.
//

import SwiftUI
import SwiftData

enum CastCrewSelection {
    case cast, crew
}

struct CastCrewView: View {
    @Query private var castCrew: [CastCrew]
    
    init(movie: Movies, selection: CastCrewSelection) {
        let movieID = movie.id
        
        let movies = #Expression<[Movies], Bool> {
            $0.contains { $0.id == movieID }
        }
        
        if selection == .cast {
            _castCrew = Query(filter: #Predicate { movies.evaluate($0.movies) && $0.character != nil },
                              sort: [SortDescriptor(\.order)],
                              animation: .default)
            
        } else if selection == .crew {
            _castCrew = Query(filter: #Predicate { movies.evaluate($0.movies) && $0.job != nil },
                              sort: [SortDescriptor(\.order)],
                              animation: .default)
        }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(Array(castCrew.enumerated()), id: \.element.id) { index, cc in
                    CastCrewImage(castCrew: cc)
                        .padding(.horizontal, index == 0 ? 0 : 10)
                }
            }
            .frame(height: 250)
        }
    }
}

#Preview("Crew",traits: .sampleData) {
    CastCrewView(movie: .testMovie, selection: .crew)
}

#Preview("Cast", traits: .sampleData) {
    CastCrewView(movie: .testMovie, selection: .cast)
}

