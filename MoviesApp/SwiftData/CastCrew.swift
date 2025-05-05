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
 final class CastCrew {
     @Attribute(.unique) var id: UUID
     var castcrewID: Int
     var name: String
     var gender: Gender //Este valor no va poder ser usado como parte del predicado, es decir no vamos a poder filtrar por este valor.
     var profileImage: URL?
     var character: String?
     var department: String?
     var job: String?
     var order: Int
     
     @Relationship(deleteRule: .cascade) var movies: [Movies]
     
     init(id: UUID = UUID(), castcrewID: Int, name: String, gender: Gender, profileImage: URL?, character: String?, department: String?, job: String?, order: Int) {
         self.id = id
         self.castcrewID = castcrewID
         self.name = name
         self.gender = gender
         self.profileImage = profileImage
         self.character = character
         self.department = department
         self.job = job
         self.order = order
         self.movies = []
     }
 }
 
 extension CastCrew {
     @MainActor static let testCast1 = CastCrew(castcrewID: 1373737,
                                                name: "Florence Pugh",
                                                gender: .female,
                                                profileImage: URL(string: "https://image.tmdb.org/t/p/w500/qqDsryavx9rwSMhDAxW6OC7oNQg.jpg"),
                                                character: "Yelena Belova",
                                                department: nil,
                                                job: nil,
                                                order: 0)
     @MainActor static let testCast2 = CastCrew(castcrewID: 60898,
                                                name: "Sebastian Stan",
                                                gender: .male,
                                                profileImage: URL(string: "https://image.tmdb.org/t/p/w500/nKZgixTbHFXpkzzIpMFdLX98GYh.jpg"),
                                                character: "Bucky Barnes / Winter Soldier",
                                                department: nil,
                                                job: nil,
                                                order: 1)
     @MainActor static let testCrew1 = CastCrew(castcrewID: 836732,
                                                name: "Jake Schreier",
                                                gender: .male,
                                                profileImage: URL(string: "https://image.tmdb.org/t/p/w500/fjspp1Tw7z1k5VhTTmMhjvg5Iew.jpg"),
                                                character: nil,
                                                department: "Directing",
                                                job: "Director",
                                                order: 0)
     @MainActor static let testCrew2 = CastCrew(castcrewID: 10850,
                                                name: "Kevin Feige",
                                                gender: .male,
                                                profileImage: URL(string: "https://image.tmdb.org/t/p/w500/2XZT80gR72to084pEj4f0SCDmDn.jpg"),
                                                character: nil,
                                                department: "Production",
                                                job: "Producer",
                                                order: 1)
 }
