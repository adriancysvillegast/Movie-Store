//
//  BrowserRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import Foundation
import UIKit

protocol BrowserRouting: AnyObject {
    var viewBrowse: BrowseView? { get }
    
    func showBrowser(fromVC: UIViewController)
}

class BrowserRouter: BrowserRouting {
    
    weak var viewBrowse: BrowseView?
    
    func showBrowser(fromVC: UIViewController) {
        
        let interactor = BrowserInteractor()
        let router = BrowserRouter()
        let presenter = BrowserPresenter(interactor: interactor, router: router)
        let view = BrowseViewController(presenter: presenter)
        
        viewBrowse = view
        interactor.presenter = presenter
        presenter.view = view
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
}
