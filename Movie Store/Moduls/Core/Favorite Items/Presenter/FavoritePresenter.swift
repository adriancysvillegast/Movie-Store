//
//  FavoritePresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation

protocol FavoritePresentable: AnyObject {
    var interactor: FavoriteInteractable { get }
    var view: FavoriteView? { get }
}

class FavoritePresenter : FavoritePresentable {
    
    // MARK: - Properties
    var view: FavoriteView?
    var interactor: FavoriteInteractable
    private var router: FavoriteRouting
    
    // MARK: - Init
    
    init(interactor: FavoriteInteractable, router: FavoriteRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Methods
    
}
