//
//  NowPlayingEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/2/24.
//

import Foundation

struct NowPlayingEntity: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let genreIds: [Int]
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
