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
    var idItem: String? { get }
    var itemsInDB: [ItemsDB] { get }
    var titleGenre : String { get }
    
    func loadCartPresenter()
    func saveItems(id: String, type: ItemType)
    func readItemsOnDB()
    func deleteItem(index: Int)
    func reloadIfItNeeded()
    
    func getRecommendation()
    func itemSelected(with item: DetailModelCell)
    func suggestionSelected(with item: ItemModelCell)
}


// MARK: - CartPresenter
class CartPresenter: CartPresentable {
    
    // MARK: - Properties
    
    var view: CartView?
    var idItem: String?
    var itemsInDB: [ItemsDB] = []
    
    private var interactor: CartInteractable
    private var router: CartRouting
    var typeItem: ItemType?
    var titleGenre : String = ""
    
    
    // MARK: - Init
    
    init(interactor: CartInteractable, router: CartRouting, idItem: String?, type: ItemType?) {
        self.interactor = interactor
        self.router = router
        self.idItem = idItem
        self.typeItem = type
    }
    
    // MARK: - Methods
    
    func loadCartPresenter() {
        
        guard let id = idItem, let type = typeItem else {
            
            self.readItemsOnDB()
            return
        }
        
        saveItems(id: id, type: type)
    }
    
    
    func saveItems(id: String, type: ItemType) {
        self.view?.showSpinner()
        interactor.createItem(
            section: .cart,
            idItem: id,
            type: type) {  [weak self] success in
                switch success {
                case true:
                    self?.itNeedUpdate()
                    self?.view?.hideError()
                    self?.readItemsOnDB()
                case false:
                    self?.view?.hideSpinner()
                    self?.view?.showError( message: "We got an error adding the item to the Cart. Please try again")
                    self?.readItemsOnDB()
                }
            }
    }
    
    
    
    func readItemsOnDB()  {
        self.view?.showSpinner()
        self.view?.hideSuggestion()
        self.view?.hideItems()
        self.view?.hideError()
        
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
                
                
                if itemsModel.isEmpty {
                    self.getRecommendation()
                }else {
                    self.view?.hideSpinner()
                    self.view?.hideError()
                    self.view?.hideSuggestion()
                    self.view?.showItems(items: itemsModel)
                }
                
            }catch errorDB.errorID {
                self.view?.hideSpinner()
                self.view?.showError( message: "we got an error trying to get the items in the cart ")
            } catch errorDB.error {
                self.view?.hideSpinner()
                self.view?.showError(message: "we got an error trying to get the items in the cart ")
            }catch errorDB.withOutData {
                self.view?.hideSpinner()
                self.view?.showError(message: "we got an error trying to get the items in the cart ")
            } catch {
                self.view?.hideSpinner()
                self.view?.showError(message: "we got an error trying to get the items in the cart ")
            }
            
        }
        
    }
    
    
    
    func deleteItem(index: Int) {
        let item = itemsInDB[index]
        let type: ItemType = item.type == "movie" ? .movie : .tv
        
        interactor.deleteItem(
            section: .cart,
            type: type,
            idDB: item.idDB
        ) { success in
            switch success {
            case true:
                self.itemsInDB.remove(at: index)
                
                self.itemsInDB.isEmpty ? self.getRecommendation() : self.view?.reloadCell(index: index)
            case false:
                
                self.view?.showAlert(title: "Error", message: "We got an error trying to delete the item")
            }
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
                }else if item.type == "tv" {
                    let tv = try await interactor.getTVDetails(id: item.id)
                    let model = MapperManager.shared.formatItem(value: tv)
                    itemsModel.append(model)
                }
            }
            view?.showItems(items: itemsModel)
        }
    }
    
    // MARK: - To reload
    private func itNeedUpdate() {
        UserDefaults.standard.set(true, forKey: "updateView")
    }
    
    private func notNeedUpdate() {
        UserDefaults.standard.set(false, forKey: "updateView")
    }
    
    func reloadIfItNeeded() {
        self.view?.showSpinner()
        if UserDefaults.standard.bool(forKey: "updateView") {
            readItemsOnDB()
            self.notNeedUpdate()
        } else if itemsInDB.isEmpty && !UserDefaults.standard.bool(forKey: "updateView") {
            getRecommendation()
        }
    }
    
    // MARK: - Recommendation
    
    func getRecommendation() {
        self.view?.showSpinner()
        self.view?.hideItems()
        self.view?.hideSuggestion()
        self.view?.hideError()
        
        Task {
            do {
                let genres = try await interactor.getGenres()
                if let genre = genres.genres.randomElement() {
                    self.titleGenre = genre.name
                    let movies = try await interactor.getRecomendationMovie(id: genre.id, page: nil)
                    
                    let itemsModel =  MapperManager.shared.formatItem(value: movies.results)
                    self.view?.hideSpinner()
                    self.view?.showSuggestion(items: itemsModel)
                    
                }else {
                    self.view?.showError(message: "We are having troubles to get the items")
                }
                
            }catch {
                print("error getRecommendation ")
                self.view?.hideSpinner()
                self.view?.showError(message: "we got an error trying to show you recommendations")
            }
            
            
        }
    }
    
    // MARK: - Details
    
    func itemSelected(with item: DetailModelCell) {
        router.showDetails(with: item)
    }
    
    func suggestionSelected(with item: ItemModelCell) {
        router.showSuggestion(with: item)
    }
    // MARK: - deinit
    deinit {
        print("CartPresenter --> \(#function)")
    }
    
}
