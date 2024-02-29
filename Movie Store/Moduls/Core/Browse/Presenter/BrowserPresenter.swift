//
//  BrowserPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserPresentable: AnyObject {
    var view: BrowseView? { get }
    var dataBrowser: [DataMovie] { get }
    func getMovies()
    
}

class BrowserPresenter: BrowserPresentable {


    
    // MARK: - Properties
    var dataBrowser: [DataMovie] = []
    
    weak var view: BrowseView?
    
    private var interactor: BrowserInteractable
    private var router: BrowserRouting
    
    init(interactor: BrowserInteractable, router: BrowserRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    
    // MARK: - Methods
    
    func getMovies() {
        
        Task {
            do{
                let topRateMovies = try await interactor.getTopRateMovies()
                let populaMovies = try await interactor.getPopularMovies()
                let upComingMovie = try await interactor.getUpComingMovies()
                let nowPlayingMovies = try await interactor.getNowPlayingMovies()
            
                let topRateTv = try await interactor.getTopRateTV()
                let popularTv = try await interactor.getPopularTV()
                let onAirTv = try await interactor.getOnAirTV()
                let tvAiring = try await interactor.getAiringTodayTV()
//
                let topRateMovieModel = MapperManager.shared.formatItem(value: topRateMovies.results)
                let popularMovieModel = MapperManager.shared.formatItem(value: populaMovies.results)
                let upComingMovieModel = MapperManager.shared.formatItem(value: upComingMovie.results)
                let nowPlayingMovieModel = MapperManager.shared.formatItem(value: nowPlayingMovies.results)
                
                let topRateTVModel = MapperManager.shared.formatItem(value: topRateTv.results)
                let popularTVModel = MapperManager.shared.formatItem(value: popularTv.results)
                let onAirTVModel = MapperManager.shared.formatItem(value: onAirTv.results)
                let airingTVModel = MapperManager.shared.formatItem(value: tvAiring.results)

                
                
                dataBrowser.append(.topRateMovie(model: topRateMovieModel))
                dataBrowser.append(.nowPlayingMovie(model: nowPlayingMovieModel))
                dataBrowser.append(.upComingMovie(model: upComingMovieModel))
                dataBrowser.append(.popularMovie(model: popularMovieModel))
                
                dataBrowser.append(.popularTV(model: popularTVModel))
                dataBrowser.append(.topRateTV(model: topRateTVModel))
                dataBrowser.append(.onAirTV(model: onAirTVModel))
                dataBrowser.append(.airingTV(model: airingTVModel))
                
                view?.getMovies(movies: dataBrowser)
            } catch APIError.errorApi{
                print("error getting info, internet problems")
            } catch APIError.errorUrl {
                print("url error")
            } catch {
                print("error")
            }
        }
        
    }
        
}
