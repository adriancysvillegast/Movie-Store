//
//  ItemFirestoreModel.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 24/4/24.
//

import Foundation

struct ItemFirestoreModel {
    let id: String
    let type: String
    
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
                let type = dictionary["type"] as? String else {
            return nil
        }
        
        self.id = id
        self.type = type
    }
}
