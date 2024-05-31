//
//  FavoriteRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation
import UIKit

protocol FavoriteRouting: AnyObject {
    var favoriteView: FavoriteView? { get }
    
    func showFavoriteFromTabBar() -> UIViewController
    func showFavorite(from: UIViewController, idItem: String, type: ItemType)
}

class FavoriteRouter: FavoriteRouting {
    
    // MARK: - Properties
    weak var favoriteView: FavoriteView?
    
    // MARK: - Init
    
    // MARK: - Methods
    func showFavoriteFromTabBar() -> UIViewController {
        
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor,
                                          router: self,
                                          idItem: nil,
                                          typeItem: nil)
        let view = FavoriteViewController(presenter: presenter)
        
        favoriteView = view
        presenter.view = favoriteView
        interactor.presenter = presenter
        return view
    }
    
    func showFavorite(from: UIViewController,
                      idItem: String,
                      type: ItemType) {
        
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor,
                                          router: self,
                                          idItem: idItem,
                                          typeItem: type)
        let view = FavoriteViewController(presenter: presenter)
        view.title = "Favorite"
        view.navigationItem.largeTitleDisplayMode = .never
        presenter.view = view
        interactor.presenter = presenter
        
        from.navigationController?.pushViewController(view, animated: true)
    }
    
    
}
