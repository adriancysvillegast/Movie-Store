//
//  ListByGenreInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 10/6/24.
//

import Foundation

protocol ListByGenreInteractable: AnyObject {
    var presenter: ListByGenrePresentable? { get }
    
    func getItems(id: Int, type: ItemType, pages: Int?) async throws -> ListByGenrerResponseEntity
}

class ListByGenreInteractor: ListByGenreInteractable {
   // MARK: - Properties
    weak var presenter: ListByGenrePresentable?
    private var service : APIManager
    
    // MARK: - Init
    
    init(service: APIManager = APIManager() ) {
        self.service = service
    }
    // MARK: - Methods
    
    func getItems(id: Int,
                  type: ItemType,
                  pages: Int?) async throws -> ListByGenrerResponseEntity {
        
        switch type {
            
        case .movie:
            do {
                let item = try await service.getRecommendation(expenting: ListByGenrerResponseEntity.self, endPoint1: "discover/movie", endPoint2: "&with_genres=\(id)&page=\(pages ?? 1)")
                return item
            } catch  {
                throw APIError.errorApi
            }
        case .tv:
            do {
                let item = try await service.getRecommendation(expenting: ListByGenrerResponseEntity.self, endPoint1: "discover/tv", endPoint2: "&with_genres=\(id)&page=\(pages ?? 1)")
                return item
            } catch  {
                throw APIError.errorApi
            }
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
