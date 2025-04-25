//
//  SampleData.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import Foundation
import SwiftData
import SwiftUI

// Creamos el contexto para los datos de prueba.
struct SampleData: PreviewModifier {
    
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(for: Movies.self, isStoredInMemoryOnly: true)
        
        let container = try ModelContainer(for: Movies.self, configurations: configuration)
        
        let moviesAppTestContainer = MovieAppPreviewContainer(context: container.mainContext)

        try moviesAppTestContainer.loadGenres()
        try moviesAppTestContainer.loadNowPlayingMovies()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
