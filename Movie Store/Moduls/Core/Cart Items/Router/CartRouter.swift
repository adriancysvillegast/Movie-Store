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
    
    func showCart(from: UIViewController, idItem: String, type: ItemType)
}

// MARK: - CartRouter

class CartRouter: CartRouting {
    
    // MARK: - Properties
    
    weak var viewCart: CartViewController?
    
    // MARK: - Methods
    
    func showCart(from: UIViewController, idItem: String, type: ItemType) {
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
    
    
}
