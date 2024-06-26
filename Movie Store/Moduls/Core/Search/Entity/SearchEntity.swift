//
//  SearchEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 9/6/24.
//

import Foundation

struct SearchEntity: Codable {
    
    let backdropPath: String?
    let id: Int
    let originalName: String?
    let mediaType: String
    let name: String?
    let profilePath: String?
    let posterPath: String?
    let originalTitle: String?
}
