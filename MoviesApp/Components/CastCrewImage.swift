//
//  CastCrewImage.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 1/5/25.
//

import SwiftUI
import SMP25Kit

struct CastCrewImage: View {
    @State private var vm = AsyncImageVM()
    let castCrew: CastCrew
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(width: 125, height: 225)
            .overlay(alignment: .top) {
                VStack(alignment: .leading) {
                    if let image = vm.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()

                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .symbolVariant(.fill)
                            .background {
                                Color.gray.opacity(0.3)
                            }
                            .clipped()
                    }
                    
                    VStack(alignment: .leading) {
                        Text(castCrew.name)
                            .font(.caption)
                            .bold()
                        
                        Text(castCrew.character ?? "")
                            .font(.caption)
                        
                        if let job = castCrew.job {
                            Text(job)
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
            .onAppear {
                vm.getImage(url: castCrew.profileImage)
            }
    }
}

#Preview("Cast Crew") {
    CastCrewImage(castCrew: .testCast1)
}

#Preview("Test Crew") {
    CastCrewImage(castCrew: .testCrew2)
}
