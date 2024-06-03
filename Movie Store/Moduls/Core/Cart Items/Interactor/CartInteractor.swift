//
//  CartInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import Foundation


// MARK: - CartInteractable

protocol CartInteractable: AnyObject {
    var presenter: CartPresentable? { get }
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity
    
    func deleteItem(section: SectionDB,
                    type: ItemType,
                    idDB: String,
                    completion: @escaping (Bool) -> Void)
}

// MARK: - CartInteractor
class CartInteractor: CartInteractable {
    var presenter: CartPresentable?
    
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/\(id)?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(DetailMovieResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/tv/\(id)?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(DetailTVResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func deleteItem(section: SectionDB,
                    type: ItemType,
                    idDB: String,
                    completion: @escaping (Bool) -> Void) {
        FirestoreDatabaseManager.shared.deleteItems(
            section: section,
            type: type,
            idDB: idDB) { success in
                completion(success)
            }
    }
}
