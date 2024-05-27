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
    var itemsInDB: [ItemsDB] { get }
    
    func addItemToCart()
    func readItemsOnDB()
}


// MARK: - CartPresenter
class CartPresenter: CartPresentable {
    
    // MARK: - Properties
    
    var view: CartView?
    var idItem: String
    var itemsInDB: [ItemsDB] = []
    
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
            print("start task")
            let type = detectType()
            
            FirestoreDatabaseManager.shared.saveItem(id: idItem, type: type) { success in
                switch success {
                case true:
                    self.view?.success()
                    self.readItemsOnDB()
                    print("self.view?.success() and self.readItemsOnDB()")
                case false:
                    self.view?.error(title: "Error", message: "We got an error adding the item to the Cart. Please try again")

                }
            }
        }
        
        
    }
    
    
    func readItemsOnDB()  {
        Task {
            var itemsModel : [DetailModelCell] = []
            do {
                let items = try await FirestoreDatabaseManager.shared.readItems(section: .cart)
                itemsInDB = items
                
                for item in items {
                    
                    switch item.type {
                    case "movie":
                        let movie = try await interactor.getMovieDetails(id: item.idObjc)
                        let model = MapperManager.shared.formatItem(value: movie)
                        itemsModel.append(model)
                    case "tv":
                        let tv = try await interactor.getTVDetails(id: item.idObjc)
                        let model = MapperManager.shared.formatItem(value: tv)
                        itemsModel.append(model)
                    default:
                        break
                    }
                }
                
                self.view?.showItems(items: itemsModel)
            }catch errorDB.errorID {
                self.view?.error(title: "Ups!", message: "we got an error trying to get the items in the cart ")
            } catch errorDB.error {
                self.view?.error(title: "Ups!", message: "we got an error trying to get the items in the cart ")
            }catch errorDB.withOutData {
                self.view?.error(title: "Ups!", message: "we got an error trying to get the items in the cart ")
            } catch {
                self.view?.error(title: "Ups!", message: "we got an error trying to get the items in the cart ")
            }
            
        }
        
    }
    
    func deleteItem(id: String) {
        Task {
            
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
