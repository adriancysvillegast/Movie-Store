//
//  DetailTVResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation

struct DetailTVResponseEntity: Codable {
    let adult: Bool?
    let backdropPath: String?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genres: [GenresResponseEntity]?
    let homepage: String?
    let id: Int
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let name: String?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage, originalName: String?
    let overview: String
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompanyEntity]
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, type: String
    let voteCount: Int?
}

struct SpokenLanguage: Codable {
    let englishName, name: String
}


