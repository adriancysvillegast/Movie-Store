//
//  PopularTVResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 28/2/24.
//

import Foundation

struct PopularTVResponseEntity: Codable{
    let page: Int
    let results: [PopularTVEntity]
    let totalPages, totalResults: Int
}
