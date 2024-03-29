//
//  DetailsItemPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation

protocol DetailsItemPresentable: AnyObject {
    var view: DetailsItemView? { get }
    var idItem: String { get }
    
    func getItem()
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
            switch typeItem {
            case .movie:
                let detailItem = try await interactor.getMovieDetails(id: idItem)
                let model = MapperManager.shared.formatItem(value: detailItem)
                view?.updateViewMovie(item: model)
            case .tv:
                let detailItem = try await interactor.getTVDetails(id: idItem)
                let model = MapperManager.shared.formatItem(value: detailItem)
                view?.updateViewTv(item: model)
            }
        }
        
    }
    
    
}
