//
//  SearchInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation

protocol SearchInteractable: AnyObject {
    var presenter: SearchPresentable? { get }
    
    
    func getMovieGenres() async throws -> GenresResponse
    func getTVGenres() async throws -> GenresResponse
}

class SearchInteractor: SearchInteractable {
    
    // MARK: - Properties
    var presenter: SearchPresentable?
    var service: APIManager
    
    
    // MARK: - Init
    
    init(service: APIManager = APIManager() ) {
        self.service = service
    }
    
    // MARK: - Methods
    
    func getMovieGenres() async throws -> GenresResponse {
        do {
            let items = try await service.get(
                expenting: GenresResponse.self,
                endPoint: "genre/movie/list" )
            
            return items
        } catch  {
            
            throw APIError.errorApi
        }
    }
    
    func getTVGenres() async throws -> GenresResponse {
        do {
            let items = try await service.get(
                expenting: GenresResponse.self,
                endPoint: "genre/tv/list" )
            
            return items
        } catch  {
            
            throw APIError.errorApi
        }
    }
}
