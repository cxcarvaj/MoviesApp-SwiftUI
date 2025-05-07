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
    let name: String
    let detail: String
    let url: URL?

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.background)
            .frame(width: 125, height: 225)
            .overlay(alignment: .top) {
                VStack {
                    if let image = vm.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .clipped()
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .scaledToFill()
                            .symbolVariant(.fill)
                            .frame(height: 110)
                            .padding()
                            .background {
                                Color.gray.opacity(0.3)
                            }
                            .clipped()
                    }
                    VStack {
                        Text(name)
                            .font(.caption)
                            .bold()
                        Text(detail)
                            .font(.caption)
                    }
                    .padding(.horizontal, 5)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 5)
            .onAppear {
                vm.getImage(url: url)
            }
            
    }
}

#Preview {
    let test = Cast.testCast1
    CastCrewImage(name: test.person.name,
              detail: test.character,
              url: test.person.profileImage)
}

#Preview {
    let test = Cast.testCast2
    CastCrewImage(name: test.person.name,
              detail: test.character,
              url: test.person.profileImage)
}
