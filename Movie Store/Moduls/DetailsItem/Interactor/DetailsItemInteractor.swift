//
//  DetailsItemInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation

protocol DetailsItemInteractable: AnyObject {
    var presenter: DetailsItemPresentable? { get }
    
    func getMovieDetails(id: String) async throws -> DetailMovieResponseEntity
    func getTVDetails(id: String) async throws -> DetailTVResponseEntity
}

class DetailsItemInteractor: DetailsItemInteractable {

    
    // MARK: - Properties
    
    weak var presenter: DetailsItemPresentable?
    
    // MARK: - Methods
    
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
    
}
