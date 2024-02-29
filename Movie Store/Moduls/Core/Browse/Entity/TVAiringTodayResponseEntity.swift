//
//  TVAiringTodayResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 28/2/24.
//

import Foundation

struct TVAiringTodayResponseEntity: Codable {
    let page: Int
    let results: [TVAiringTodayEntity]
    let totalPages, totalResults: Int
}
