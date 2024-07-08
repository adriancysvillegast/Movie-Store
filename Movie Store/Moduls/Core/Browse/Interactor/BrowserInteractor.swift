//
//  BrowserInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserInteractable : AnyObject {
    var presenter: BrowserPresentable? { get }
    var service: APIManager { get }
    
    func getTopRateMovies(page: Int?) async throws -> TopRateMovieResponseEntity
    func getPopularMovies(page: Int?) async throws -> PopularMoviesResponseEntity
    func getNowPlayingMovies(page: Int?) async throws -> NowPlayingResponseEntity
    func getUpComingMovies(page: Int?) async throws -> UpComingResponseEntity
    
    func getTopRateTV(page: Int?) async throws -> TopRateTVResponseEntity
    func getPopularTV(page: Int?) async throws -> PopularTVResponseEntity
    func getOnAirTV(page: Int?) async throws -> OnAirTVResponseEntity
    func getAiringTodayTV(page: Int?) async throws -> TVAiringTodayResponseEntity
    func logOutAccount() -> Bool
}

class BrowserInteractor: BrowserInteractable {
    
    // MARK: - Properties
    
    weak var presenter: BrowserPresentable?
    private var authManager: AuthManager
    var service: APIManager
    
    init(authManager: AuthManager = AuthManager(),
         service: APIManager = APIManager() ) {
        self.authManager = authManager
        self.service = service
    }
    
    // MARK: - Methods
    
    func getTopRateMovies(page: Int?) async throws -> TopRateMovieResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: TopRateMovieResponseEntity.self,
                endPoint: "movie/top_rated",
                nextPage: page)
            return items
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getPopularMovies(page: Int?) async throws -> PopularMoviesResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: PopularMoviesResponseEntity.self,
                endPoint: "movie/popular", nextPage: page)
            return items
        } catch {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getNowPlayingMovies(page: Int?) async throws -> NowPlayingResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: NowPlayingResponseEntity.self,
                endPoint: "movie/now_playing",
                nextPage: page)
            return items
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getUpComingMovies(page: Int?) async throws -> UpComingResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: UpComingResponseEntity.self,
                endPoint: "movie/upcoming",
                nextPage: page)
            return items
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getTopRateTV(page: Int?) async throws -> TopRateTVResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: TopRateTVResponseEntity.self,
                endPoint: "tv/top_rated",
                nextPage: page)
            return items
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getPopularTV(page: Int?) async throws -> PopularTVResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: PopularTVResponseEntity.self,
                endPoint: "tv/popular",
                nextPage: page)
            return items
        } catch  {
//            print(error.localizedDescription)
            throw APIError.errorApi
        }
    }
    
    func getOnAirTV(page: Int?) async throws -> OnAirTVResponseEntity {
        
        do {
            let items = try await service.get(
                expenting: OnAirTVResponseEntity.self,
                endPoint: "discover/tv",
                nextPage: page)
            return items
        } catch  {
            throw APIError.errorApi
        }
    }

    func getAiringTodayTV(page: Int?) async throws -> TVAiringTodayResponseEntity {
        do {
            let items = try await service.get(
                expenting: TVAiringTodayResponseEntity.self,
                endPoint: "tv/airing_today",
                nextPage: page)
            return items
        } catch  {
            throw APIError.errorApi
        }
        
    }

    func logOutAccount() -> Bool {
        let result = authManager.logOut()
        return result
    }
    
}
