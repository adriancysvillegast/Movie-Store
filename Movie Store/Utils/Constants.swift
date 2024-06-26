//
//  Constants.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

struct Constants {
    static let baseURL: String = ProcessInfo.processInfo.environment["baseURL"] ?? "https://api.themoviedb.org/3"
    static let token: String = ProcessInfo.processInfo.environment["token"] ?? ""
    
    
    static let collectionItems : String = "cart-Items"
}
