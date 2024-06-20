//
//  ListByGenreRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 10/6/24.
//

import Foundation
import UIKit

protocol ListByGenreRouting: AnyObject {
    
    var viewListByGenre: ListByGenreViewController? { get }
    var detailRouter: DetailsItemRouter? { get }
    
    func showItemsByGenre(from: UIViewController, id: Int, type: ItemType, name: String)
    func goToDetails(id: String, type: ItemType)
}

class ListByGenreRouter: ListByGenreRouting {
    
    // MARK: - Properties
    var viewListByGenre: ListByGenreViewController?
    var detailRouter: DetailsItemRouter?
    
    
    // MARK: - Methods
    
    func showItemsByGenre(from: UIViewController,
                          id: Int,
                          type: ItemType, name: String) {
        
        detailRouter = DetailsItemRouter()
        
        let interactor = ListByGenreInteractor()
        let presenter = ListByGenrePresenter(
            interactor: interactor,
            router: self,
            type: type,
            id: id)
        let view = ListByGenreViewController(presenter: presenter)
        view.title = name
        viewListByGenre = view
        
        presenter.view = view
        interactor.presenter = presenter
        from.navigationController?.pushViewController(view, animated: true)
    }
    
    
    func goToDetails(id: String, type: ItemType) {
        
        guard let view = viewListByGenre else {
            return
        }
        
        detailRouter?.showDetails(idItem: id, type: type, fromVC: view)
        
    }
    
}
