//
//  BrowserRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation
import UIKit

protocol BrowserRouting: AnyObject {
    var viewBrowse: BrowseViewController? { get }
    var itemDetail: DetailsItemRouting? { get }
    
    func showBrowser(fromVC: UIViewController)
    func showDetails(id: String, type: ItemType)
    
}

class BrowserRouter: BrowserRouting {
    
    // MARK: - Properties
    weak var viewBrowse: BrowseViewController?
    var itemDetail: DetailsItemRouting?
    
    
    // MARK: - Methods
    
    func showBrowser(fromVC: UIViewController) {
        itemDetail = DetailsItemRouter()

        let interactor = BrowserInteractor()
        let presenter = BrowserPresenter(interactor: interactor, router: self)
        let view = BrowseViewController(presenter: presenter)
        viewBrowse = view
        presenter.view = view
        interactor.presenter = presenter
        
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
    func showDetails(id: String, type: ItemType) {
        guard let fromVC = viewBrowse else {
            print("se fue a la mierda")
            return
        }
        
        itemDetail?.showDetails(idItem: id, type: type, fromVC: fromVC)
    }
}
