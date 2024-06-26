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
    var titleGenre: String { get }
    
    func loadFavoritePresenter()
    
    func createItem(id: String, type: ItemType)
    func readItems()
    func deleteItem(index: Int)
    func getRecommendation()
    func itemSelected(with item: DetailModelCell)
    func suggestionSelected(with item: ItemModelCell)
}

class FavoritePresenter : FavoritePresentable {
    
    
    // MARK: - Properties
    
    var view: FavoriteView?
    var interactor: FavoriteInteractable
    private var router: FavoriteRouting
    var idItem: String?
    var typeItem: ItemType?
    var itemsInDB: [ItemsDB] = []
    var titleGenre: String = ""
    
    
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
    
    
    func loadFavoritePresenter() {
        guard let id = idItem, let type = typeItem else {
            self.readItems()
            return
        }
        createItem(id: id, type: type)
    }
    
    
    func createItem(id: String, type: ItemType) {
        self.view?.showSpinner()
        
        interactor.createItem(id: id, type: type) { [weak self] success in
            switch success {
            case true:
                self?.view?.hideSpinner()
                self?.view?.showAlert(title: "Added", message: "The item was added successfully")
                self?.readItems()
            case false:
                self?.view?.showError(message: "We got an error trying to add the item to your favorite list, please try again.")
                self?.view?.hideSpinner()
            }
        }
    }


    func readItems() {
        self.view?.hideError()
        self.view?.hideSuggestions()
        self.view?.hideFavoriteItems()
        self.view?.showSpinner()
    
        Task {
            var itemsModel: [DetailModelCell] = []
            do {
                
                let items = try await interactor.readItems()
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
                itemsModel.isEmpty ? getRecommendation() : self.view?.showFavoriteItems(items: itemsModel)
                
                self.view?.hideSpinner()
            } catch {
                self.view?.showError(message: "We got an error trying to get the items")
                self.view?.hideSpinner()
            }
        }
    }
    
    func deleteItem(index: Int) {
        
        let item = itemsInDB[index]
        let type: ItemType = item.type == "movie" ? .movie : .tv
        
        interactor.deleteItems(
            section: .favorite,
            type: type ,
            idDB: item.idDB) { success in
                switch success {
                case true:
                    self.itemsInDB.remove(at: index)
                    self.itemsInDB.isEmpty ? self.getRecommendation() : self.view?.reloadCell(index: index)
                case false:
                    self.view?.showAlert(title: "Error", message: "we got an error trying to delete the item")
                }
            }
    }
    
    // MARK: - Recommendations
    
    func getRecommendation() {
        self.view?.showSpinner()
        self.view?.hideFavoriteItems()
        self.view?.hideSuggestions()
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
        router.showDetails(with: item)
    }
}
