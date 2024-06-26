//
//  OnAirTVResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 28/2/24.
//

import Foundation

struct OnAirTVResponseEntity: Codable {
    let page: Int
    let results: [OnAirTVEntity]
    let totalPages, totalResults: Int
}
