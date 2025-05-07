//
//  CastCrew.swift
//  MoviesApp
//
//  Created by Carlos Xavier Carvajal Villegas on 30/4/25.
//

import Foundation
import SwiftData

enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
}

@Model
final class Person {
    @Attribute(.unique) var id: Int
    var name: String
    var gender: Gender //Este valor no va poder ser usado como parte del predicado, es decir no vamos a poder filtrar por este valor.
    var profileImage: URL?
    @Relationship(deleteRule: .cascade, inverse: \Cast.person) var cast: [Cast]
    @Relationship(deleteRule: .cascade, inverse: \Crew.person) var crew: [Crew]
    
    init(id: Int, name: String, gender: Gender, profileImage: URL?) {
        self.id = id
        self.name = name
        self.gender = gender
        self.profileImage = profileImage
        self.cast = []
        self.crew = []
    }
}

@Model
final class Cast {
    @Attribute(.unique) var id: UUID
    var character: String
    var order: Int
    
    @Relationship(deleteRule: .cascade) var person: Person
    @Relationship(deleteRule: .cascade) var movies: [Movies]

    init(id: UUID = UUID(), character: String, order: Int, person: Person) {
        self.id = id
        self.character = character
        self.order = order
        self.person = person
        self.movies = []
    }
}

@Model
final class Crew {
    @Attribute(.unique) var id: UUID
    var department: String
    var job: String
    
    @Relationship(deleteRule: .cascade) var person: Person
    @Relationship(deleteRule: .cascade) var movies: [Movies]
    
    init(id: UUID = UUID(), department: String, job: String, person: Person) {
        self.id = id
        self.department = department
        self.job = job
        self.person = person
        self.movies = []
    }
}

extension Person {
    @MainActor static let florencia = Person(id: 1373737,
                                                  name: "Florence Pugh",
                                                  gender: .female,
                                                  profileImage: URL(string: "https://image.tmdb.org/t/p/w500/qqDsryavx9rwSMhDAxW6OC7oNQg.jpg"))
    @MainActor static let sebastianStan = Person(id: 60898,
                                                      name: "Sebastian Stan",
                                                      gender: .male,
                                                      profileImage: URL(string: "https://image.tmdb.org/t/p/w500/nKZgixTbHFXpkzzIpMFdLX98GYh.jpg"))
    @MainActor static let kevinFeige = Person(id: 10850,
                                                   name: "Kevin Feige",
                                                   gender: .male,
                                                   profileImage: URL(string: "https://image.tmdb.org/t/p/w500/2XZT80gR72to084pEj4f0SCDmDn.jpg"))
    @MainActor static let jakeSchreier = Person(id: 836732,
                                                     name: "Jake Schreier",
                                                     gender: .male,
                                                     profileImage: URL(string: "https://image.tmdb.org/t/p/w500/fjspp1Tw7z1k5VhTTmMhjvg5Iew.jpg"))
}

extension Cast {
    @MainActor static let testCast1 = Cast(character: "Yelena Belova", order: 0, person: .florencia)
    @MainActor static let testCast2 = Cast(character: "Bucky Barnes / Winter Soldier", order: 1, person: .sebastianStan)
}

extension Crew {
    @MainActor static let testCrew1 = Crew(department: "Production", job: "Production", person: .kevinFeige)
    @MainActor static let testCrew2 = Crew(department: "Directing", job: "Director", person: .jakeSchreier)
}
