//
//  TopRateEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

struct TopRateEntity: Codable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
