//
//  FavoriteInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation

protocol FavoriteInteractable: AnyObject {
    var presenter: FavoritePresentable? { get }
}

class FavoriteInteractor: FavoriteInteractable {
    
    // MARK: - Properties
   weak var presenter: FavoritePresentable?
    
    // MARK: - Init
    
    // MARK: - Methods
    
}
