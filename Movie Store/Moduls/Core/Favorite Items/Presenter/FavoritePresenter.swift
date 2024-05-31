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
    var idItem: String? { get }
    
    func addItems()
    func getItems()
    
}

class FavoritePresenter : FavoritePresentable {
    
    // MARK: - Properties
    var view: FavoriteView?
    var interactor: FavoriteInteractable
    private var router: FavoriteRouting
    var idItem: String?
    var typeItem: ItemType?
    var itemsInDB: [ItemsDB] = []
    private var itemsModel: [DetailModelCell] = []
    
    // MARK: - Init
    
    init(interactor: FavoriteInteractable,
         router: FavoriteRouting,
         idItem: String?,
         typeItem: ItemType?) {
        self.interactor = interactor
        self.router = router
        self.idItem = idItem
        self.typeItem = typeItem
    }
    
    // MARK: - Methods
    
    func addItems() {
        self.view?.activateSpinner()
        if let id = idItem, let type = typeItem {
            interactor.saveItem(id: id, type: type, completion: { success in
                switch success {
                case true:
                    self.view?.showAlert(title: "Added", message: "The item was added successfully")
                    self.getItems()
                case false:
                    self.view?.showAlert(title: "Error", message: "We got an error trying to add the item to your favorite list, please try again.")
                    self.view?.desactivateSpinner()
                }
            })
            
        } else {
            getItems()
        }
    }
    
    
    func getItems() {
        Task {
            
            do {
                let items = try await interactor.getItems()
                itemsInDB = items
                
                for item in items {
                    switch item.type {
                    case "movie":
                        let item = try await interactor.getMovieDetails(id: item.idObjc)
                        let model = MapperManager.shared.formatItem(value: item)
                        itemsModel.append(model)
                    default:
                        let item = try await interactor.getTVDetails(id: item.idObjc)
                        let model = MapperManager.shared.formatItem(value: item)
                        itemsModel.append(model)
                    }
                }
                self.view?.getItems(items: itemsModel)
                self.view?.desactivateSpinner()
            } catch {
                self.view?.showAlert(title: "Error", message: "We got an error trying to get the items of your favorite list, please try again.")
                self.view?.desactivateSpinner()
            }
        }
    }
    
    
}
