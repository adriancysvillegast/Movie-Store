//
//  FavoriteRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import Foundation
import UIKit

protocol FavoriteRouting: AnyObject {
    var favoriteView: FavoriteViewController? { get }
    var details: DetailsItemRouter? { get }
    
    func showFavoriteFromTabBar() -> UIViewController
    func showFavorite(from: UIViewController, idItem: String, type: ItemType)
    func showDetails(with item: DetailModelCell)
}

class FavoriteRouter: FavoriteRouting {
    
    // MARK: - Properties
    weak var favoriteView: FavoriteViewController?
    var details: DetailsItemRouter?
    // MARK: - Init
    
    // MARK: - Methods
    func showFavoriteFromTabBar() -> UIViewController {
        details = DetailsItemRouter()
        
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor,
                                          router: self,
                                          idItem: nil,
                                          typeItem: nil)
        let view = FavoriteViewController(presenter: presenter)
        
        favoriteView = view
        presenter.view = favoriteView
        interactor.presenter = presenter
        return view
    }
    
    func showFavorite(from: UIViewController,
                      idItem: String,
                      type: ItemType) {
        
        let interactor = FavoriteInteractor()
        let presenter = FavoritePresenter(interactor: interactor,
                                          router: self,
                                          idItem: idItem,
                                          typeItem: type)
        let view = FavoriteViewController(presenter: presenter)
        view.title = "Favourite"
        view.navigationItem.largeTitleDisplayMode = .never
        presenter.view = view
        interactor.presenter = presenter
        
        from.navigationController?.pushViewController(view, animated: true)
    }
    
    func showDetails(with item: DetailModelCell) {
        guard let vc = favoriteView else {
            return
        }
        
        details?.showDetails(idItem: item.id, type: item.isAMovie ? .movie : .tv, fromVC: vc)
    }
}
