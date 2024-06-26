//
//  NowPlayingResponseEntity.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/2/24.
//

import Foundation

struct NowPlayingResponseEntity: Codable {
    let page: Int
    let results: [NowPlayingEntity]
    let totalPages, totalResults: Int
}
