//
//  SearchInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 6/6/24.
//

import Foundation

protocol SearchInteractable: AnyObject {
    var presenter: SearchPresentable? { get }
    
}

class SearchInteractor: SearchInteractable {
    
    // MARK: - Properties
    var presenter: SearchPresentable?
    var service: APIManager
    
    
    // MARK: - Init
    
    init(service: APIManager = APIManager() ) {
        self.service = service
    }
    
    
}
