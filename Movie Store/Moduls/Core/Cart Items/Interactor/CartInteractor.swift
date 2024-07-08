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
    
    func createItem(section: SectionDB,
                  idItem: String,
                  type: ItemType,
                  completion: @escaping (Bool) -> Void)
    
    func getGenres() async throws -> GenresResponse
    func getRecomendationMovie(id: Int,
                               page: Int?) async throws -> ListByGenrerResponseEntity
    
}

// MARK: - CartInteractor
class CartInteractor: CartInteractable {
    
    // MARK: - Properties
    
    var presenter: CartPresentable?
    private var service : APIManager
    // MARK: - Init
    
    init(service: APIManager = APIManager() ) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity {
        
        do {
            let item = try await service.get(
                expenting: DetailMovieResponseEntity.self,
                endPoint: "movie/\(id)")
            return item
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity {
        
        do {
            let item = try await service.get(
                expenting: DetailTVResponseEntity.self,
                endPoint: "tv/\(id)")
            return item
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func deleteItem(section: SectionDB,
                    type: ItemType,
                    idDB: String,
                    completion: @escaping (Bool) -> Void) {
        FirestoreDatabaseManager.shared.deleteItem(
            section: section,
            type: type,
            idDB: idDB) { success in
                completion(success)
            }
    }
    
    func createItem(
        section: SectionDB,
        idItem: String,
        type: ItemType,
        completion: @escaping (Bool) -> Void
    ) {
        
        FirestoreDatabaseManager.shared.createItem(
            id: idItem,
            typeItem: type,
            section: section) { success in
                completion(success)
            }
    }
    
    
    // MARK: - Recomendation
    
    
    func getGenres() async throws -> GenresResponse {
        do {
            let items = try await service.get(
                expenting: GenresResponse.self,
                endPoint: "genre/movie/list" )
            
            return items
        } catch  {
            
            throw APIError.errorApi
        }
    }
    
    
    func getRecomendationMovie(id: Int, page: Int?) async throws -> ListByGenrerResponseEntity {
        do {
            let items = try await service.getRecommendation(
                expenting: ListByGenrerResponseEntity.self,
                endPoint1: "discover/movie",
                endPoint2: "&with_genres=\(id)")
            
            return items
        } catch  {
            throw APIError.errorApi
        }
    }
    
}
