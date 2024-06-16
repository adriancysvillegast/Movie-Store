//
//  ListByGenrePresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 10/6/24.
//

import Foundation

protocol ListByGenrePresentable: AnyObject {
    var view: ListByGenreView? { get }
    
    func getItems()
}

class ListByGenrePresenter : ListByGenrePresentable{
    
    // MARK: - Properties
    
    weak var view: ListByGenreView?
    var interactor: ListByGenreInteractable
    var router: ListByGenreRouting
    var type: ItemType
    var id: Int
    var itemsEntity: ListByGenrerResponseEntity?
    
    // MARK: - Init
    
    init(interactor: ListByGenreInteractable,
         router: ListByGenreRouting,
         type: ItemType,
         id: Int ) {
        self.interactor = interactor
        self.router = router
        self.type = type
        self.id = id
    }
    
    // MARK: - Methods
    
    func getItems() {
        Task {
            do{
                let items = try await interactor.getItems(id: id, type: type, pages: nil)
                
                itemsEntity = items
                
                let model =  MapperManager.shared.formatItem(value: items.results)
                self.view?.showItems(items: model)
            }catch {
                
                self.view?.hideCollection()
                self.view?.showError(message: "Error to load data")
            }
            
        }
    }
    
    
}
