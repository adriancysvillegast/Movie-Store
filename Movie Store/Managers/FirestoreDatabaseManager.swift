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
    
    func saveItem(id: String, typeItem: ItemType, section: SectionDB,
                  completion: @escaping (Bool) -> Void) {
        
        guard let user = auth.user?.uid else {
            completion(false)
            //            print("false -----")
            return
        }
        
        switch section {
        case .cart:
            
            switch typeItem {
            case .movie:
                self.ref.child("itemsOnBag").child(user).child("items").child("movies").childByAutoId().setValue(id) { error, success in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            case .tv:
                self.ref.child("itemsOnBag").child(user).child("items").child("tv").childByAutoId().setValue(id) { error, success in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            
            
        case .favorite:
            switch typeItem {
            case .movie:
                self.ref.child("itemsOnBag").child(user).child("items").child("favorite").child("movies").childByAutoId().setValue(id) { error, success in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            case .tv:
                self.ref.child("itemsOnBag").child(user).child("items").child("favorite").child("tv").childByAutoId().setValue(id) { error, success in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
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
                    return items
                } catch  {
                    throw errorDB.error
                }
                
            case .favorite:
                
                
                do {
                    
                    let snapMovie = try await ref.child("itemsOnBag/\(id)/items/favorite/movies/").getData()
                    let movieObj = snapMovie.value as? [String: String] ?? [:]
                    for (key, value ) in movieObj {
                        let item = ItemsDB(type: "movie", idObjc: value, idDB: key)
                        items.append(item)
                    }
                    
                    let snaptv = try await ref.child("itemsOnBag/\(id)/items/favorite/tv/").getData()
                    let tvObj = snaptv.value as? [String: String] ?? [:]
                    for (key, value ) in tvObj {
                        let item = ItemsDB(type: "tv", idObjc: value, idDB: key)
                        items.append(item)
                    }
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
    
    func deleteItems(
        section: SectionDB,
        type: ItemType,
        idDB: String,
        completion: @escaping (Bool) -> Void
    ) {
        
        guard let id = auth.user?.uid else {
            return
        }
        
        switch section {
        case .cart:
            
            switch type {
            case .movie:
                let item = ref.child("itemsOnBag/\(id)/items/movies/\(idDB)")
                item.removeValue { error, reference in
                    if let error = error {
                        completion(false)
                    }else {
                        completion(true)
                    }
                }
            case .tv:
                let item = ref.child("itemsOnBag/\(id)/items/tv/\(idDB)")
                item.removeValue { error, reference in
                    if let error = error {
                        completion(false)
                    }else {
                        completion(true)
                    }
                }
            }
        case .favorite:
            
            switch type {
            case .movie:
                let item = ref.child("itemsOnBag/\(id)/items/favorite/movies/\(idDB)")
                item.removeValue { error, reference in
                    if let error = error {
                        completion(false)
                    }else {
                        completion(true)
                    }
                }
                
                
                
            case .tv :
                let item = ref.child("itemsOnBag/\(id)/items/favorite/tv/\(idDB)")
                item.removeValue { error, reference in
                    if let error = error {
                        completion(false)
                    }else {
                        completion(true)
                    }
                }
            }
        }
    }
    
}

// MARK: - DB Struct and type errors 

enum SectionDB {
    //dif section on firebase db
    case cart
    case favorite
}

struct ItemsDB {
    let type, idObjc, idDB : String
}

enum errorDB: Error {
    case error
    case withOutData
    case errorID
}
