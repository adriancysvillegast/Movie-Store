//
//  ListByGenreRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 10/6/24.
//

import Foundation
import UIKit

protocol ListByGenreRouting: AnyObject {
    
    var view: ListByGenreViewController? { get }
    
    func showItemsByGenre(from: UIViewController, id: Int, type: ItemType, name: String)
}

class ListByGenreRouter: ListByGenreRouting {
    
    // MARK: - Properties
    weak var view: ListByGenreViewController?
    
    // MARK: - Methods
    
    func showItemsByGenre(from: UIViewController,
                          id: Int,
                          type: ItemType, name: String) {
        let interactor = ListByGenreInteractor()
        let presenter = ListByGenrePresenter(
            interactor: interactor,
            router: self,
            type: type,
            id: id)
        let view = ListByGenreViewController(presenter: presenter)
        view.title = name
        
        presenter.view = view
        interactor.presenter = presenter
        from.navigationController?.pushViewController(view, animated: true)
    }
}
