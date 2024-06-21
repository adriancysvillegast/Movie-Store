//
//  PersonDetailResponse.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 20/6/24.
//

import Foundation

struct PersonDetailResponse: Codable {
    
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
}
