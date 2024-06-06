//
//  FavoriteInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation

protocol FavoriteInteractable: AnyObject {
    var presenter: FavoritePresentable? { get }
    
    func saveItem(id: String,
                  type: ItemType,
                  completion: @escaping (Bool) -> Void)
    func getItems() async throws -> [ItemsDB]
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
    
    func saveItem(
        id: String,
        type: ItemType,
        completion: @escaping (Bool) -> Void
    ){
        
        FirestoreDatabaseManager.shared.saveItem(
            id: id,
            typeItem: type,
            section: .favorite
        ) { success  in
            completion(success)
        }
        
    }
    
    func getItems() async throws -> [ItemsDB] {
        
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
        FirestoreDatabaseManager.shared.deleteItems(section: section, type: type, idDB: idDB) { success in
            completion(success)
        }
    }
    
    // MARK: - Details
    
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
