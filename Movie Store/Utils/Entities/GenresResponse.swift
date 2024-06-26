//
//  GenresResponse.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 5/6/24.
//

import Foundation

struct GenresResponse: Codable {
    let genres: [Genre]
}



struct Genre: Codable {
    let id: Int
    let name: String
    
}
