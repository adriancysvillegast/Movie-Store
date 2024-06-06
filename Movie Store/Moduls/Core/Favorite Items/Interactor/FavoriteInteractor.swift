//
//  FavoriteInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation

protocol FavoriteInteractable: AnyObject {
    var presenter: FavoritePresentable? { get }
    
    func createItem(id: String,
                  type: ItemType,
                  completion: @escaping (Bool) -> Void)
    func readItems() async throws -> [ItemsDB]
    func deleteItems(section: SectionDB,
                     type: ItemType,
                     idDB: String,
                     completion: @escaping (Bool) -> Void)
    
    func getGenres() async throws -> GenresResponse
    func getRecomendationMovie(id: Int, page: Int?) async throws -> ListByGenrerResponseEntity
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity
}

class FavoriteInteractor: FavoriteInteractable {
    
    // MARK: - Properties
    
    weak var presenter: FavoritePresentable?
    var service: APIManager
    
    // MARK: - Init
    
    init(service: APIManager = APIManager() ) {
        self.service = service
    }
    // MARK: - CRUD
    
    func createItem(
        id: String,
        type: ItemType,
        completion: @escaping (Bool) -> Void
    ){
        
        FirestoreDatabaseManager.shared.createItem(
            id: id,
            typeItem: type,
            section: .favorite
        ) { success  in
            completion(success)
        }
        
    }
    
    func readItems() async throws -> [ItemsDB] {
        
        do {
            let items = try await FirestoreDatabaseManager.shared.readItems(section: .favorite)
            return items
        } catch {
            throw errorDB.error
        }
    }
    
    func deleteItems(
        section: SectionDB,
        type: ItemType,
        idDB: String,
        completion: @escaping (Bool) -> Void
    ) {
        FirestoreDatabaseManager.shared.deleteItem(
            section: section,
            type: type,
            idDB: idDB
        ) { success in
            completion(success)
        }
    }
    
    // MARK: - Details
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity {
        
        do {
            let item = try await service.get(
                expenting: DetailMovieResponseEntity.self,
                endPoint: "/movie/\(id)")
            return item
        } catch  {
            throw APIError.errorApi
        }
    }

    func getTVDetails(id: String) async throws -> DetailTVResponseEntity {
        
        do {
            let item = try await service.get(
                expenting: DetailTVResponseEntity.self,
                endPoint: "/tv/\(id)")
            return item
        } catch {
            throw APIError.errorApi
        }
    }
    
    // MARK: - Recommendations
    
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
