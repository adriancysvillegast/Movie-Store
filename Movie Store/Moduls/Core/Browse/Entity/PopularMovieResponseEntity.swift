//
//  PopularMovieResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/2/24.
//

import Foundation

struct PopularMoviesResponseEntity: Codable {
    let page: Int
    let results: [PopularMovieEntity]
    let totalPages, totalResults: Int
}
