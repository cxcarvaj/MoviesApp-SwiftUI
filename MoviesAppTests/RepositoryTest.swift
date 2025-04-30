//
//  RepositoryTest.swift
//  MoviesAppTests
//
//  Created by Carlos Xavier Carvajal Villegas on 29/4/25.
//

import Foundation
@testable import MoviesApp

struct RepositoryTest: NetworkRepository {
    var session: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [NetworkMockInterface.self]
        return URLSession(configuration: configuration)
    }
    var decoder: JSONDecoder {
         let decoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
         formatter.locale = Locale(identifier: "en_US_POSIX")
         decoder.dateDecodingStrategy = .formatted(formatter)
         return decoder
     }
}
