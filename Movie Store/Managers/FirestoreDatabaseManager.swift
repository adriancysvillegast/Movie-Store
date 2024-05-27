//
//  FirestoreDatabaseManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 13/5/24.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase


final class FirestoreDatabaseManager {
    
    // MARK: - Properties
    
    static let shared = FirestoreDatabaseManager()
    
    private var ref = Database.database().reference()
    private var auth = AuthManager()
    
    func saveItem(id: String, type: String,
                  completion: @escaping (Bool) -> Void) {
        
        guard let user = auth.user?.uid else {
            completion(false)
            print("false -----")
            return
        }

        switch type {
        case "movie":
            self.ref.child("itemsOnBag").child(user).child("items").child("movies").childByAutoId().setValue(id) { error, success in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            
        default:
            self.ref.child("itemsOnBag").child(user).child("items").child("tv").childByAutoId().setValue(id) { error, success in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        }
    }
    
    func readItems(section: SectionDB) async throws -> [ItemsDB] {
        var items: [ItemsDB] = []
    
        if let id = auth.user?.uid {
            
            switch section {
            case .cart:
                
                do {
                    
                    let snapMovie = try await ref.child("itemsOnBag/\(id)/items/movies/").getData()
                    let movieObj = snapMovie.value as? [String: String] ?? [:]
                    for (key, value ) in movieObj {
                        let item = ItemsDB(type: "movie", idObjc: value, idDB: key)
                        items.append(item)
                    }
                    
                    let snaptv = try await ref.child("itemsOnBag/\(id)/items/tv/").getData()
                    let tvObj = snaptv.value as? [String: String] ?? [:]
                    for (key, value ) in tvObj {
                        let item = ItemsDB(type: "tv", idObjc: value, idDB: key)
                        items.append(item)
                    }
//
//                    //            movies
//                    try ref.child("itemsOnBag/\(id)/items/movies/").getData
//                    { error, data in
//                        guard error == nil, let data = data?.value else {
//                            print("error != nil \(error!.localizedDescription)")
//                            return
//                        }
//
//                        let obj = data as? [String : String] ?? [:]
//                        for (key, value) in obj {
//                            let item = ItemsDB(type: "movie", idObjc: value, idDB: key)
//                            items.append(item)
//
//                        }
//
//                    }
//
//                    //            tv
//                   try ref.child("itemsOnBag/\(id)/items/tv/").getData
//                    { error, data in
//
//                        guard error == nil,
//                              let data = data?.value else {
//                            return
//                        }
//
//                        let obj = data as? [String : String] ?? [:]
//                        for (key, value) in obj {
//                            let item = ItemsDB(type: "tv", idObjc: value, idDB: key)
//                            items.append(item)
//                        }
//
//                    }
                    
                    return items
                } catch  {
                    throw errorDB.error
                }
            }
            
            
            
        }else {
            print("error with id user")
            throw errorDB.errorID
        }
        
    }
    
    
    
}

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


enum SectionDB {
    case cart
}

struct ItemsDB {
    let type, idObjc, idDB : String
}

enum errorDB: Error {
    case error
    case withOutData
    case errorID
}
