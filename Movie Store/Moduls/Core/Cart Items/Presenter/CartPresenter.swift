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
        
        Task {
            let type = detectType()
            
            let success = try await FirestoreManager.shared.addItem(
                id: idItem,
                type: type
            )
            
            switch success {
            case true:
                view?.success()
            case false:
                view?.errorAddingItem()
            }
            
            let itemsSaved = try await FirestoreManager.shared.readItems()
            getItemInfo(items: itemsSaved)
        }
    }
    
    private func detectType() -> String {
        
        if typeItem == .movie {
            return "movie"
        }else {
            return "tv"
        }
    }
    
    private func getItemInfo(items: [ItemFirestoreModel]) {
        
        Task {
            var itemsModel: [DetailModelCell] = []
            
            for item in items {
                
                if item.type == "movie" {
                    
                    let movie = try await interactor.getMovieDetails(id: item.id)
                    let model = MapperManager.shared.formatItem(value: movie)
                    itemsModel.append(model)
                }else {
                    let tv = try await interactor.getTVDetails(id: item.id)
                    let model = MapperManager.shared.formatItem(value: tv)
                    itemsModel.append(model)
                }
            }
            view?.showItems(items: itemsModel)
        }
    }
    
}
