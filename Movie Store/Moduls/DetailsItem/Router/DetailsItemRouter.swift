//
//  DetailsItemRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation
import UIKit

protocol DetailsItemRouting: AnyObject {
    var viewDetail: DetailsItemViewController? { get }
    var cartRouter: CartRouting? { get }
    var favoriteRouter: FavoriteRouting? { get }
    
    func showDetails(idItem: String, type: ItemType, fromVC: UIViewController)
    func showCart(itemId: String, type: ItemType)
    func saveInFavoriteList(itemID: String, type: ItemType)
}

class DetailsItemRouter: DetailsItemRouting {
    var cartRouter: CartRouting?
    var favoriteRouter: FavoriteRouting?
    var viewDetail: DetailsItemViewController?
    
    func showDetails(idItem: String, type: ItemType, fromVC: UIViewController) {
        cartRouter = CartRouter()
        favoriteRouter = FavoriteRouter()
        
        let interactor = DetailsItemInteractor()
        let presenter = DetailsItemPresenter(interactor: interactor, router: self, idItem: idItem, type: type)
        let view = DetailsItemViewController(presenter: presenter)
        
        viewDetail = view
        presenter.view = view
        interactor.presenter = presenter
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
    func showCart(itemId: String, type: ItemType) {
        guard let VC = viewDetail else {
            print("error in \(#function)")
            return
        }
        cartRouter?.showCart(from: VC, idItem: itemId, type: type)
    }
    
    func saveInFavoriteList(itemID: String, type: ItemType) {
        guard let vc = viewDetail else {
            print("error in \(#function)")
            return
        }
        
        favoriteRouter?.showFavorite(from: vc, idItem: itemID, type: type)
    }
}
