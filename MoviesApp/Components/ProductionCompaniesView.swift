//
//  ProductionCompaniesView.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 1/5/25.
//

import SwiftUI

struct ProductionCompaniesView: View {
    let productionCompanies: [ProductionCompany]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Production Companies")
                .font(.headline)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(productionCompanies) { productionCompany in
                        VStack {
                            AsyncImage(url: productionCompany.logoImage) { image in
                                image
                            } placeholder: {
                                Image(systemName: "movieclapper")
                                    .resizable()
                                    .frame(width: 90, height: 90)
                            }

                            Text(productionCompany.name)
                            
                        }
                    }
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

#Preview {
    ProductionCompaniesView(productionCompanies: [.testCompany])
}
