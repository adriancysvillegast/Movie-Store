//
//  TopRateTVEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 28/2/24.
//

import Foundation

struct TopRateTVEntity: Codable {
    let backdropPath, firstAirDate: String?
    let genreIds: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
}
