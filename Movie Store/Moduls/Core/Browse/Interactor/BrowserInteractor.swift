//
//  BrowserInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserInteractable : AnyObject {
    var presenter: BrowserPresentable? { get }
    
    func getTopMovies() async throws -> TopRateResponseEntity
}

class BrowserInteractor: BrowserInteractable {
    
    // MARK: - Properties
    
    weak var presenter: BrowserPresentable?
    
    // MARK: - Methods
    
    func getTopMovies() async throws -> TopRateResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/top_rated?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(TopRateResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    
    
    
}
