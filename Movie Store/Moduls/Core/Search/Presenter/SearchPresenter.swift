//
//  SearchPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation

protocol SearchPresentable: AnyObject {
    var view: SearchView? { get }
    var interactor: SearchInteractable { get }
}

class SearchPresenter: SearchPresentable{
    
    weak var view: SearchView?
    var interactor: SearchInteractable
    
    // MARK: - Init
    
    init(interactor: SearchInteractable ) {
        self.interactor = interactor
    }
    
    // MARK: - Methods
    
}
