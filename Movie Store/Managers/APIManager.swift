//
//  APIManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 5/6/24.
//

import Foundation

final class APIManager {
    
    // MARK: - Genres
    
    func get<T: Codable>(
        expenting: T.Type,
        endPoint: String
    ) async throws -> T {
        
        guard let url = URL(string: Constants.baseURL + "/\(endPoint)?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
//        print(url.absoluteString)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(expenting, from: data)
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func get<T: Codable>(
        expenting: T.Type,
        endPoint: String,
        nextPage: Int?
    ) async throws -> T {
        
        guard let url = URL(string: Constants.baseURL + "/\(endPoint)?api_key=" + Constants.token + "&page=\(nextPage ?? 1)") else {
            throw APIError.errorUrl
        }
//        print(url.absoluteString)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(expenting, from: data)
        } catch  {
            
            throw APIError.errorApi
        }
    }
    
    // MARK: - Recommendations
    
    func getRecommendation<T: Codable>(
        expenting: T.Type,
        endPoint1: String,
        endPoint2: String
    ) async throws -> T {
        
        guard let url = URL(string: Constants.baseURL + "/\(endPoint1)?api_key=" + Constants.token + "\(endPoint2)") else {
            throw APIError.errorUrl
        }
//        print(url.absoluteString)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(expenting, from: data)
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    // MARK: - Search
    func search<T: Codable>(
        expenting: T.Type,
        endPoint: String
    ) async throws -> T {
        
        guard let url = URL(string: Constants.baseURL + "/\(endPoint)&api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
//        print(url.absoluteString)
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(expenting, from: data)
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
}
