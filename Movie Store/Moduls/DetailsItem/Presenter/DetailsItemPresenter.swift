//
//  DetailsItemPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation
import UIKit

protocol DetailsItemPresentable: AnyObject {
    var view: DetailsItemView? { get }
    var idItem: String { get }
    
    func getItem()
    func addToCart(from: UIViewController)
    func addToFavorite(from: UIViewController)
}

class DetailsItemPresenter: DetailsItemPresentable {

    // MARK: - Properties
    weak var view: DetailsItemView?
    private let interactor: DetailsItemInteractable
    private let router: DetailsItemRouting
    
    var idItem: String
    var typeItem: ItemType
    
    init(interactor: DetailsItemInteractable, router: DetailsItemRouting, idItem: String, type: ItemType) {
        self.interactor = interactor
        self.router = router
        self.idItem = idItem
        self.typeItem = type
    }
    
    // MARK: - Methods
    
    func getItem() {
        
        Task {
            self.view?.showSpinner()
            
            switch typeItem {
            case .movie:
                do{
                    let detailItem = try await interactor.getMovieDetails(id: idItem)
                    let model = MapperManager.shared.formatItem(value: detailItem)
                    self.view?.hideSpiner()
                    view?.showMovieDetail(item: model)
                }catch {
                    view?.hideSpiner()
                    view?.showError(message: "We have troubles to show the info")
                }
            case .tv:
                
                do {
                    let detailItem = try await interactor.getTVDetails(id: idItem)
                    let model = MapperManager.shared.formatItem(value: detailItem)
                    self.view?.hideSpiner()
                    view?.showTVDetail(item: model)
                } catch  {
                    view?.hideSpiner()
                    view?.showError(message: "We have troubles to show the info")
                }
            case .person:
                
                do {
                    let person = try await interactor.getPersonDetails(id: idItem)
                    let model = MapperManager.shared.formatItem(value: person)
                    self.view?.hideSpiner()
                    view?.showPerson(person: model)
                } catch  {
                    view?.hideSpiner()
                    view?.showError(message: "We have troubles to show the info")
                }
            }
        }
        
    }
    
    func addToCart(from: UIViewController) {
        router.showCart(itemId: idItem, type: typeItem)
    }
    
    func addToFavorite(from: UIViewController) {
        router.saveInFavoriteList(itemID: idItem, type: typeItem)
    }
}
