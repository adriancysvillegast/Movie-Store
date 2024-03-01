//
//  TopRateMovieResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

struct TopRateMovieResponseEntity: Codable {
    
    let page: Int
    let results: [TopRateEntity]
    let totalPages, totalResults: Int
}
