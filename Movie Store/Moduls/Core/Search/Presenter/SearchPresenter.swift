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
}

class SearchPresenter: SearchPresentable{
    
    weak var view: SearchView?
    var interactor: SearchInteractable
    
    // MARK: - Init
    
    init(interactor: SearchInteractable ) {
        self.interactor = interactor
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
        guard let text = query, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        
    }
}


