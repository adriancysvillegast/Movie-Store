//
//  BrowserInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserInteractable : AnyObject {
    var presenter: BrowserPresentable? { get }
    
    func getTopRateMovies() async throws -> TopRateMovieResponseEntity
    func getPopularMovies() async throws -> PopularMoviesResponseEntity
    func getNowPlayingMovies() async throws -> NowPlayingResponseEntity
    func getUpComingMovies() async throws -> UpComingResponseEntity
    
    func getTopRateTV() async throws -> TopRateTVResponseEntity
    func getPopularTV() async throws -> PopularTVResponseEntity
    func getOnAirTV() async throws -> OnAirTVResponseEntity
    func getAiringTodayTV() async throws -> TVAiringTodayResponseEntity
}

class BrowserInteractor: BrowserInteractable {
    
    // MARK: - Properties
    
    weak var presenter: BrowserPresentable?
    
    // MARK: - Methods
    
    func getTopRateMovies() async throws -> TopRateMovieResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/movie/top_rated?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(TopRateMovieResponseEntity.self, from: data)
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
    
    
    func getTopRateTV() async throws -> TopRateTVResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/tv/top_rated?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(TopRateTVResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getPopularTV() async throws -> PopularTVResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/tv/popular?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PopularTVResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
    
    func getOnAirTV() async throws -> OnAirTVResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/discover/tv?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        print(url.absoluteString)
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(OnAirTVResponseEntity.self, from: data)
        } catch {
            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getAiringTodayTV() async throws -> TVAiringTodayResponseEntity {
        guard let url = URL(string: Constants.baseURL + "/tv/airing_today?api_key=" + Constants.token) else {
            throw APIError.errorUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(TVAiringTodayResponseEntity.self, from: data)
        } catch  {
            throw APIError.errorApi
        }
    }
}
