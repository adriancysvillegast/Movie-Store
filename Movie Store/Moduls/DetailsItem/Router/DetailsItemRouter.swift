//
//  DetailsItemRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import Foundation
import UIKit

protocol DetailsItemRouting: AnyObject {
    func showDetails(idItem: String, type: ItemType, fromVC: UIViewController)
}

class DetailsItemRouter: DetailsItemRouting {
    
    func showDetails(idItem: String, type: ItemType, fromVC: UIViewController) {
        let interactor = DetailsItemInteractor()
        let presenter = DetailsItemPresenter(interactor: interactor, router: self, idItem: idItem, type: type)
        let view = DetailsItemViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
    
}
