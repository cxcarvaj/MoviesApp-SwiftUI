//
//  MovieDTO.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 24/4/25.
//


import Foundation

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let releaseDate: Date
    let posterPath: URL?
    let backdropPath: URL?
    let voteAverage: Double
    let genreIds: [Int]
    
    /// init(from decoder: Decoder)
    /// Este inicializador es un requerimiento del protocolo Decodable (parte de Codable). Cuando tu struct implementa Codable, necesitas una forma de convertir datos externos (como JSON) a tu objeto Swift.
    /// En casos simples, Swift generaría automáticamente este inicializador, pero aquí se proporciona una implementación personalizada porque se necesitan transformaciones especiales para posterPath y backdropPath (convertir strings a URLs con prefijos).
    init(from decoder: Decoder) throws {
        /// ¿Qué es CodingKeys y de dónde sale?
        /// CodingKeys es una enumeración que Swift genera automáticamente cuando implementas Codable. Aunque no está explícitamente en tu código, el compilador la crea con casos que coinciden con los nombres de las propiedades de tu struct.
        /**
         ## Se vería así (aunque es implícita):
         ```swift
         enum CodingKeys: String, CodingKey {
             case id
             case title
             case originalTitle
             case originalLanguage
             case overview
             case releaseDate
             case posterPath
             case backdropPath
             case voteAverage
             case genreIds
         }
         ```
        */
        /// Esta enumeración mapea los nombres de las propiedades Swift a las claves en el formato de datos externo. Si alguna vez necesitas que el nombre en tu código sea diferente al del JSON, puedes declarar esta enumeración explícitamente.
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)

        if let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) {
            self.posterPath = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        } else {
            self.posterPath = nil
        }

        if let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) {
            self.backdropPath = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        } else {
            self.backdropPath = nil
        }
    }
}

struct MovieResponseDTO: Codable {
    let results: [MovieDTO]
}
