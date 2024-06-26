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
    func getNextPage()
    func itemWasSelected(id: Int)
}

class ListByGenrePresenter : ListByGenrePresentable{
    
    // MARK: - Properties
    
    weak var view: ListByGenreView?
    var interactor: ListByGenreInteractable
    private var router: ListByGenreRouting
    private var type: ItemType
    private var id: Int
    private var itemsEntity: [ListByGenrerResponseEntity] = []
    private var items: [ItemModelCell] = []
    private var newItems: [ItemModelCell] = []
    
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
                let itemsData = try await interactor.getItems(id: id, type: type, pages: nil)
                
                itemsEntity.append(itemsData)
                
                items = MapperManager.shared.formatItem(value: itemsData.results)
                self.view?.showItems(items: items)
            }catch {
                
                self.view?.hideCollection()
                self.view?.showError(message: "Error to load data")
            }
            
        }
    }
    
    func getNextPage() {
        
        Task {
            
            guard let items = itemsEntity.last else {
                return
            }
            
            if items.page < items.totalPages {
                
                newItems = []
                let page = items.page + 1
                do {
                    let itemsData = try await interactor.getItems(id: id,
                                                                  type: type,
                                                                  pages: page)
                    itemsEntity.append(itemsData)
                    newItems = MapperManager.shared.formatItem(value: itemsData.results)
                    self.view?.addNext(items: newItems)
                    
                } catch  {
                    self.view?.showAlert(title: "Error",
                                         message: "We had trouble to show more items")
                }
            }
        }
    }
    
    func itemWasSelected(id: Int) {
        router.goToDetails(id: String(id), type: type)
    }
    
}
