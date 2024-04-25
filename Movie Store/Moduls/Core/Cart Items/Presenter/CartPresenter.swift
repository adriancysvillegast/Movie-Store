//
//  CartPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import Foundation

// MARK: - CartPresentable

protocol CartPresentable: AnyObject {
    var view: CartView? { get }
    var idItem: String { get }
    
    
    func addItemToCart()
}


// MARK: - CartPresenter
class CartPresenter: CartPresentable {
    
    // MARK: - Properties
    
    var view: CartView?
    var idItem: String
    
    private var interactor: CartInteractable
    private var router: CartRouting
    var typeItem: ItemType
    
    
    // MARK: - Init
    
    init(interactor: CartInteractable, router: CartRouting, idItem: String, type: ItemType) {
        self.interactor = interactor
        self.router = router
        self.idItem = idItem
        self.typeItem = type
    }
    
    // MARK: - Methods
    func addItemToCart() {
//        llamar a las funciones que guardan los datos en la db de firebase
        Task {
        let type = detectType()
            
            let success = try await FirestoreManager.shared.addItem(
                id: idItem,
                type: type
            )
            
            switch success {
            case true:
                print("trueeeeee")
                view?.success()
            case false:
                print("falssseeeee")
                view?.errorAddingItem()
            }
            
            await FirestoreManager.shared.readItems()
        }
    }
    
    private func detectType() -> String {
        if typeItem == .movie {
            return "movie"
        }else {
            return "tv"
        }
    }
    
}
