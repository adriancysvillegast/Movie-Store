//
//  DetailModelCell.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/3/24.
//

import Foundation

struct DetailModelCell {
    let isAMovie: Bool
    let adult: Bool?
    let backdropPath: URL?
    let episodeRunTimeTV: [Int]?
    let firstAirDate: String?
    let genres: [GenresResponseEntity]?
    let id: String
    let inProductionTv: Bool?
    let lenguage: String
    let name: String
    let overview: String
    let numSeasons, numSpisodes: Int?
    let productionCompanies: [Companies]
    let artwork: URL?
    let voteCount: Int?
    
}

struct Companies {
    let id: Int
    let logoPath: URL?
    let name, originCountry: String
}


