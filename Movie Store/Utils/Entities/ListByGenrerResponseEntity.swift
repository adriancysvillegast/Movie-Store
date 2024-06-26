//
//  ListByGenrerResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 5/6/24.
//

import Foundation

struct ListByGenrerResponseEntity: Codable {
    let page: Int
    let results: [ListByGenreEntity]
    let totalPages, totalResults: Int
}
