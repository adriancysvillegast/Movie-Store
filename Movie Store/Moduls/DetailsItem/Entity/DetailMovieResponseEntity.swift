//
//  DetailMovieResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation

struct DetailMovieResponseEntity: Codable {
    
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [GenresResponseEntity]
    let homepage: String
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyEntity]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguageEntity]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}

struct ProductionCompanyEntity: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
}


struct SpokenLanguageEntity: Codable {
    let englishName, name: String
}
