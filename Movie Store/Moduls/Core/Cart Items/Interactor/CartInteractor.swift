//
//  CartInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import Foundation


// MARK: - CartInteractable

protocol CartInteractable: AnyObject {
    var presenter: CartPresentable? { get }
}

// MARK: - CartInteractor
class CartInteractor: CartInteractable {
    var presenter: CartPresentable?
    
    
}
