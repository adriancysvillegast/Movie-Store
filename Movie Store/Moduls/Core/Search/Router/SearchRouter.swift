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
    var listByGenreRouter: ListByGenreRouter? { get }
    var detailRouter: DetailsItemRouter? { get }
    
    func showSearch() -> UIViewController
    func showItemsGenre( id: Int, type: ItemType, name: String)
    func showItem(id: String, type: ItemType)
}

class SearchRouter: SearchRouting {
    // MARK: - Properties
    
    weak var searchView: SearchViewController?
    var listByGenreRouter: ListByGenreRouter?
    var detailRouter: DetailsItemRouter?
    
    // MARK: - Methods
    
    func showSearch() -> UIViewController {
        listByGenreRouter = ListByGenreRouter()
        detailRouter = DetailsItemRouter()
        
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
        
        listByGenreRouter?.showItemsByGenre(from: vc, id: id, type: type, name: name)
    }
    
    func showItem(id: String, type: ItemType) {
        guard let vc = searchView else {
            return
        }
        detailRouter?.hideNavBotton = true
        detailRouter?.showDetails(idItem: id, type: type, fromVC: vc)
    }
}
