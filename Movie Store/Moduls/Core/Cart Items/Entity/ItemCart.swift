//
//  ItemCart.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 31/5/24.
//

import Foundation

struct ItemCart: Codable {
    let id, type: String
}


extension ItemCart {
    var dictionary: [String: Any] {
        return [
            "id": id,
            "type": type
        ]
    }
}
