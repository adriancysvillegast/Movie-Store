//
//  BrowserInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserInteractable : AnyObject {
    var presenter: BrowserPresentable? { get }
    
    func getTopRateMovies() async throws -> TopRateResponseEntity
    func getPopularMovies() async throws -> PopularMoviesResponseEntity
    func getNowPlayingMovies() async throws -> NowPlayingResponseEntity
    func getUpComingMovies() async throws -> UpComingResponseEntity
}

class BrowserInteractor: BrowserInteractable {
    
    // MARK: - Properties
    
    weak var presenter: BrowserPresentable?
    
    // MARK: - Methods
    
    func getTopRateMovies() async throws -> TopRateResponseEntity {
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
    
    func getPopularMovies() async throws -> PopularMoviesResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/popular?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PopularMoviesResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getNowPlayingMovies() async throws -> NowPlayingResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/now_playing?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(NowPlayingResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getUpComingMovies() async throws -> UpComingResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/upcoming?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(UpComingResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
}
