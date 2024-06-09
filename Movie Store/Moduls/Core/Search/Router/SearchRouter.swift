//
//  SearchRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation
import UIKit

protocol SearchRouting: AnyObject {
    var searchView: SearchViewController? { get }

    func showSearch() -> UIViewController
}

class SearchRouter: SearchRouting {
    
    
    // MARK: - Properties
    
    weak var searchView: SearchViewController?
    
    
    // MARK: - Methods
    
    func showSearch() -> UIViewController {
        
        let interactor = SearchInteractor()
        let presenter = SearchPresenter(interactor: interactor, router: self)
        let view = SearchViewController(presenter: presenter)
        searchView = view
        interactor.presenter = presenter
        presenter.view = searchView
        
        return view
    }
    

    
}
