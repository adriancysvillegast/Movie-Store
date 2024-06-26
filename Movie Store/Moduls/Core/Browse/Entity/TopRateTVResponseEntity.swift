//
//  TopRateTVResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 28/2/24.
//

import Foundation

struct TopRateTVResponseEntity : Codable{
    let page: Int
    let results: [TopRateTVEntity]
    let totalPages, totalResults: Int
}
