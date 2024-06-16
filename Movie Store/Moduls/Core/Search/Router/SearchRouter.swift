//
//  SearchRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation
import UIKit

protocol SearchRouting: AnyObject {
    var searchView: SearchViewController? { get }
    var listByGenre: ListByGenreRouter? { get }
    
    func showSearch() -> UIViewController
    func showItemsGenre( id: Int, type: ItemType, name: String)
}

class SearchRouter: SearchRouting {
    // MARK: - Properties
    
    weak var searchView: SearchViewController?
    var listByGenre: ListByGenreRouter?
    
    // MARK: - Methods
    
    func showSearch() -> UIViewController {
        listByGenre = ListByGenreRouter()
        
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(interactor: interactor, router: self)
        let view = SearchViewController(presenter: presenter)
        searchView = view
        interactor.presenter = presenter
        presenter.view = searchView
        
        return view
    }
    

    
    func showItemsGenre( id: Int, type: ItemType, name: String) {
        guard let vc = searchView else { return }
        
        listByGenre?.showItemsByGenre(from: vc, id: id, type: type, name: name)
    }
    
}
