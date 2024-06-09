//
//  SearchResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 9/6/24.
//

import Foundation

struct SearchResponseEntity: Codable {
    let page: Int
    let results: [SearchEntity]
    let totalPages, totalResults: Int
}
