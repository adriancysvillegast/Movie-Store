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
    
    func showFavorite() -> UIViewController
}

class FavoriteRouter: FavoriteRouting {
    
    // MARK: - Properties
    weak var favoriteView: FavoriteView?
    
    // MARK: - Init
    
    // MARK: - Methods
    func showFavorite() -> UIViewController {
        
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor, router: self)
        let view = FavoriteViewController(presenter: presenter)
        
        favoriteView = view
        presenter.view = favoriteView
        interactor.presenter = presenter
        return view
    }
    
}
