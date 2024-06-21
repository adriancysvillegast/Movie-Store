//
//  DetailsItemInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation

protocol DetailsItemInteractable: AnyObject {
    var presenter: DetailsItemPresentable? { get }
    var service: APIManager { get }
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity
    func getPersonDetails(id: String) async throws -> PersonDetailResponse
}

class DetailsItemInteractor: DetailsItemInteractable {

    
    // MARK: - Properties
    
    weak var presenter: DetailsItemPresentable?
    var service: APIManager
    
    // MARK: - Init
    
    init(service: APIManager = APIManager()) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity {
        
        do {
           let items = try await service.get(
                expenting: DetailMovieResponseEntity.self,
                endPoint: "/movie/\(id)")
            
            return items
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity {
        
        do {
           let items = try await service.get(expenting: DetailTVResponseEntity.self, endPoint: "/tv/\(id)")
            return items
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getPersonDetails(id: String) async throws -> PersonDetailResponse {
        
        do {
           let items = try await service.get(expenting: PersonDetailResponse.self, endPoint: "/person/\(id)")
            return items
        } catch  {
            throw APIError.errorApi
        }
    }
    
}
