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
                let topRateMovies = try await interactor.getTopRateMovies().results
                let populaMovies = try await interactor.getPopularMovies().results
                let upComingMovie = try await interactor.getUpComingMovies().results
                let nowPlayingMovies = try await interactor.getNowPlayingMovies().results
                
                let topRateModel = MapperManager.shared.formatItem(value: topRateMovies)
                let popularModel = MapperManager.shared.formatItem(value: populaMovies)
                let upComingModel = MapperManager.shared.formatItem(value: upComingMovie)
                let nowPlayingModel = MapperManager.shared.formatItem(value: nowPlayingMovies)
                
                dataBrowser.append(.topRate(model: topRateModel))
                dataBrowser.append(.nowPlaying(model: nowPlayingModel))
                dataBrowser.append(.upComing(model: upComingModel))
                dataBrowser.append(.popular(model: popularModel))
                
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
