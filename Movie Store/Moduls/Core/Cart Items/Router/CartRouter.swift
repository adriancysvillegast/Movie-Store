//
//  CartRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import Foundation
import UIKit
// MARK: - CartRouting

protocol CartRouting: AnyObject {
    var viewCart: CartViewController? { get }
    var detailsRouter: DetailsItemRouter? { get }
    
    func showCart(from: UIViewController, idItem: String, type: ItemType)
    func showCartFromTabBar() -> UIViewController
    func showDetails(with item: DetailModelCell)
    func showSuggestion(with item: ItemModelCell)
}

// MARK: - CartRouter

class CartRouter: CartRouting {
    
    // MARK: - Properties
    
    weak var viewCart: CartViewController?
    var detailsRouter: DetailsItemRouter?
    
    // MARK: - Methods
    
    func showCart(from: UIViewController, idItem: String, type: ItemType) {
        
        detailsRouter = DetailsItemRouter()
        
        let interactor = CartInteractor()
        let presenter = CartPresenter(
            interactor: interactor,
            router: self,
            idItem: idItem,
            type: type
        )
        let view = CartViewController(presenter: presenter)
        
        viewCart = view
        presenter.view = view
        interactor.presenter = presenter
        from.navigationController?.pushViewController(view, animated: true)
    }
    
    func showCartFromTabBar() -> UIViewController {
        
        detailsRouter = DetailsItemRouter()
        
        let interactor = CartInteractor()
        let presenter = CartPresenter(
            interactor: interactor,
            router: self,
            idItem: nil,
            type: nil)
        let view = CartViewController(presenter: presenter)
        
        viewCart = view
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
    
    
    func showDetails(with item: DetailModelCell) {
        guard let vc = viewCart else { return }
        detailsRouter?.hideNavBotton = true
        detailsRouter?.showDetails(idItem: item.id, type: item.isAMovie ? .movie : .tv, fromVC: vc)
    }
    
    func showSuggestion(with item: ItemModelCell) {
        guard let vc = viewCart else { return }
        detailsRouter?.showDetails(idItem: String(item.id), type: .movie, fromVC: vc)
    }
}
