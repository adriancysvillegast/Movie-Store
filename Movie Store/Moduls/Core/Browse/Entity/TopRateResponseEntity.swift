//
//  TopRateResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

struct TopRateResponseEntity: Codable {
    let page: Int
    let results: [TopRateEntity]
    let totalPages, totalResults: Int
}
