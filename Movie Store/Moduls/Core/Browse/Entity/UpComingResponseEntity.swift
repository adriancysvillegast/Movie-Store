//
//  UpComingResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/2/24.
//

import Foundation

struct UpComingResponseEntity: Codable {
    let dates: Dates
    let page: Int
    let results: [UpComingEntity]
    let totalPages, totalResults: Int
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
}
