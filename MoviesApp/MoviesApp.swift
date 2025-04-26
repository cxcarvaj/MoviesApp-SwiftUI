//
//  MoviesApp.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//

import SwiftUI
import SwiftData

let APIKey = ""

@main
struct MoviesApp: App {
    //Con esto mantengo a mi ModelActor permanezca vivo durante toda la ejecucion de mi app
    @State private var container: MoviesAppContainer?
    @State private var vm = MoviesVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
        //Aqui se le pasan el o los modelos de mayor nivel (o primer grado) jerarquico.
        //En este caso solo Movies, ya que contiene a Genres y se crea por la relacion que existe
        .modelContainer(for: Movies.self) { result in
            guard case .success(let container) = result else { return }
//            self.container = MoviesAppContainer(modelContainer: container)
            Task(priority: .low) {
                await initialize(container)
            }
        }
    }
    
    func initialize(_ container: ModelContainer) async {
        do {
            self.container = MoviesAppContainer(modelContainer: container)
            try await self.container?.initialize()
        } catch {
            print("Error initializing data: \(error)")
        }
    }
}
