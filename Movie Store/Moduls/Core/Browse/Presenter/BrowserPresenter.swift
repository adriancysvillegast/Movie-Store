//
//  BrowserPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation

protocol BrowserPresentable: AnyObject {
    var view: BrowseView? { get }

    var topRateMovieModel: [ItemModelCell] { get }
    var populaMovieModel: [ItemModelCell] { get }
    var upCominMovieModel: [ItemModelCell] { get }
    var nowPlayingMovieModel: [ItemModelCell] { get }
    var topRateTVModel: [ItemModelCell] { get }
    var popularTVModel: [ItemModelCell] { get }
    var onAirTVModel: [ItemModelCell] { get }
    var airingTodayTvModel: [ItemModelCell] { get }
    
    func getMovies()
    func validatePagesToDownloadData(option: RowSelected)
}

class BrowserPresenter: BrowserPresentable {
    
    // MARK: - Properties

    weak var view: BrowseView?
    private var interactor: BrowserInteractable
    private var router: BrowserRouting
    
    var topRateMoviesContainer: [TopRateMovieResponseEntity] = []
    var populaMoviesContainer: [PopularMoviesResponseEntity] = []
    var upComingMovieContainer: [UpComingResponseEntity] = []
    var nowPlayingMoviesContainer: [NowPlayingResponseEntity] = []
    var topRateTVContainer: [TopRateTVResponseEntity] = []
    var popularTVContainer: [PopularTVResponseEntity] = []
    var onAirTVContainer: [OnAirTVResponseEntity] = []
    var airingTodayTVContainer: [TVAiringTodayResponseEntity] = []
    
    var topRateMovieModel: [ItemModelCell] = []
    var populaMovieModel: [ItemModelCell] = []
    var upCominMovieModel: [ItemModelCell] = []
    var nowPlayingMovieModel: [ItemModelCell] = []
    var topRateTVModel: [ItemModelCell] = []
    var popularTVModel: [ItemModelCell] = []
    var onAirTVModel: [ItemModelCell] = []
    var airingTodayTvModel: [ItemModelCell] = []
    
    init(interactor: BrowserInteractable, router: BrowserRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    
    // MARK: - Methods
    
    func getMovies() {
        
        Task {
            do{
                let topRateMovies = try await interactor.getTopRateMovies(page: nil)
                let populaMovies = try await interactor.getPopularMovies(page: nil)
                let upComingMovie = try await interactor.getUpComingMovies(page: nil)
                let nowPlayingMovies = try await interactor.getNowPlayingMovies(page: nil)
                //to save Pages and all info
                self.topRateMoviesContainer.append(topRateMovies)
                self.populaMoviesContainer.append(populaMovies)
                self.upComingMovieContainer.append(upComingMovie)
                self.nowPlayingMoviesContainer.append(nowPlayingMovies)
                
                
                let topRateTv = try await interactor.getTopRateTV(page: nil)
                let popularTv = try await interactor.getPopularTV(page: nil)
                let onAirTv = try await interactor.getOnAirTV(page: nil)
                let tvAiring = try await interactor.getAiringTodayTV(page: nil)
                
                self.topRateTVContainer.append(topRateTv)
                self.popularTVContainer.append(popularTv)
                self.onAirTVContainer.append(onAirTv)
                self.airingTodayTVContainer.append(tvAiring)
                
                let topRateMovieFormat = MapperManager.shared.formatItem(value: topRateMovies.results)
                let popularMovieFormat = MapperManager.shared.formatItem(value: populaMovies.results)
                let upComingMovieFormat = MapperManager.shared.formatItem(value: upComingMovie.results)
                let nowPlayingMovieFormat = MapperManager.shared.formatItem(value: nowPlayingMovies.results)
                
                topRateMovieModel.append(contentsOf: topRateMovieFormat)
                populaMovieModel.append(contentsOf: popularMovieFormat)
                upCominMovieModel.append(contentsOf: upComingMovieFormat)
                nowPlayingMovieModel.append(contentsOf: nowPlayingMovieFormat)
                
                let topRateTVFormat = MapperManager.shared.formatItem(value: topRateTv.results)
                let popularTVFormat = MapperManager.shared.formatItem(value: popularTv.results)
                let onAirTVFormat = MapperManager.shared.formatItem(value: onAirTv.results)
                let airingTVFormat = MapperManager.shared.formatItem(value: tvAiring.results)
                
                topRateTVModel.append(contentsOf: topRateTVFormat)
                popularTVModel.append(contentsOf: popularTVFormat)
                onAirTVModel.append(contentsOf: onAirTVFormat)
                airingTodayTvModel.append(contentsOf: airingTVFormat)
                
                view?.updateView(topRateMovie: topRateMovieModel, popularMovie: populaMovieModel, upComing: upCominMovieModel, nowPlayingMovie: nowPlayingMovieModel, topRateTV: topRateTVModel, popularTV: popularTVModel, onAirTVModel: onAirTVModel, airingTodayTvModel: airingTodayTvModel)
                
            } catch APIError.errorApi{
                print("error getting info, internet problems")
            } catch APIError.errorUrl {
                print("url error")
            } catch {
                print("error")
            }
        }
        
    }
    
    func validatePagesToDownloadData(option: RowSelected) {
        Task {
            
            switch option {
                
            case .popularMovie:
                guard let movies = self.populaMoviesContainer.last else { return }
                if movies.page < movies.totalPages {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getPopularMovies(page: page)
                    self.populaMoviesContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    
                    self.populaMovieModel.append(contentsOf: model)
                }
            case .topRateMovie:
                guard let movies = self.topRateMoviesContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getTopRateMovies(page: page)
                    self.topRateMoviesContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.topRateMovieModel.append(contentsOf: model)
                }
            case .upComingMovie:
                guard let movies = self.upComingMovieContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getUpComingMovies(page: page)
                    self.upComingMovieContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.upCominMovieModel.append(contentsOf: model)
                }
            case .nowPlayingMovie:
                guard let movies = self.nowPlayingMoviesContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getNowPlayingMovies(page: page)
                    self.nowPlayingMoviesContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.nowPlayingMovieModel.append(contentsOf: model)
                }
            case .topRateTV:
                guard let movies = self.topRateMoviesContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getTopRateTV(page: page)
                    self.topRateTVContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.topRateTVModel.append(contentsOf: model)
                }
            case .popularTV:
                guard let movies = self.popularTVContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getTopRateTV(page: page)
                    self.topRateTVContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.popularTVModel.append(contentsOf: model)
                }
            case .onAirTV:
                guard let movies = self.onAirTVContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getOnAirTV(page: page)
                    self.onAirTVContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.onAirTVModel.append(contentsOf: model)
                }
            case .airingTV:
                guard let movies = self.airingTodayTVContainer.last else { return }
                if movies.page < movies.totalPages  {
                    let page = movies.page + 1
                    let newMovies = try await interactor.getAiringTodayTV(page: page)
                    self.airingTodayTVContainer.append(newMovies)
                    let model = MapperManager.shared.formatItem(value: newMovies.results)
                    self.onAirTVModel.append(contentsOf: model)
                }
            }
        }
        
    }

    
}

enum RowSelected {
    case topRateMovie
    case popularMovie
    case upComingMovie
    case nowPlayingMovie
    case topRateTV
    case popularTV
    case onAirTV
    case airingTV
}
