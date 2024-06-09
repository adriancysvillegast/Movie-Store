//
//  SearchPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation

protocol SearchPresentable: AnyObject {
    var view: SearchView? { get }
    var interactor: SearchInteractable { get }
    
    func showGenres()
    func getQuery(query: String?)
    func mappingModel(items: [SearchEntity]) -> [ItemsResult]
}

class SearchPresenter: SearchPresentable{
    
    weak var view: SearchView?
    var interactor: SearchInteractable
    var router: SearchRouting?
    // MARK: - Init
    
    init(interactor: SearchInteractable, router: SearchRouting ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Methods
    
    func showGenres() {
        
        Task {
            do{
                let movieItems = try await interactor.getMovieGenres()
                let movieGenreModel = MapperManager.shared.formatItem(value: movieItems)
                
                let tvItems = try await interactor.getTVGenres()
                let tvGenreModel = MapperManager.shared.formatItem(value: tvItems)
                
                self.view?.showGenres(movieItems: movieGenreModel, tvItems: tvGenreModel)
                
            }catch {
                self.view?.showAlert(title: "Error", message: "We got an error trying to load the categories")
                self.view?.showErrorLabel(text: "We can't load the categories")
            }
        }
    }
    
    func getQuery(query: String?) {
        
        Task {
            guard let text = query, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                self.view?.hideSpinner()
                self.view?.showGenres()
                self.view?.hideResults()
                return
            }
            
            var result = [ItemsResult]()
            
            do {
                self.view?.hideGenres()
                self.view?.showSpinner()
                
                let items = try await interactor.searchItems(with: text)
                
                result = self.mappingModel(items: items.results)
                self.view?.hideSpinner()
                self.view?.showResult(items: result)
            }catch {
                print(error.localizedDescription)
                self.view?.hideSpinner()
                self.view?.showGenres()
                self.view?.showAlert(title: "Error",
                                     message: "Error trying to get Items \(query ?? "")")
                self.view?.hideResults()
            }
            
        }
    }
    
    func mappingModel(items: [SearchEntity]) -> [ItemsResult] {
        var result: [ItemsResult] = []
        var people : [ItemModelCell] = []
        var movie : [ItemModelCell] = []
        var tv : [ItemModelCell] = []
        
        for item in items {
            switch item.mediaType {
            case "person":
                people.append(ItemModelCell(
                    id: item.id,
                    artWork: URL(string: "https://image.tmdb.org/t/p/w200" + (item.profilePath ?? "")),
                    releaseDate: "",
                    title: (item.name) ?? ""))
                
            case "movie":
                movie.append(ItemModelCell(
                    id: item.id,
                    artWork: URL(string: "https://image.tmdb.org/t/p/w200" + (item.posterPath ?? "")),
                    releaseDate: "",
                    title: ((item.originalName ?? item.name) ??  item.originalTitle) ?? ""))
            case "tv":
                tv.append(ItemModelCell(
                    id: item.id,
                    artWork: URL(string: "https://image.tmdb.org/t/p/w200" + (item.posterPath ?? "")),
                    releaseDate: "",
                    title: (item.originalName ?? item.name) ?? ""))
            default:
                break
            }
        }
        
        result.append(.person(model: people))
        result.append(.movie(model: movie))
        result.append(.tv(model: tv))
        
        return result
    }
    
    
}

enum ItemsResult {
    case movie (model: [ItemModelCell])
    case tv (model: [ItemModelCell])
    case person (model: [ItemModelCell])
}
