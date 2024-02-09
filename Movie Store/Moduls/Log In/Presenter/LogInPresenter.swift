//
//  LogInPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation


protocol LogInPresentable: AnyObject {
    var view: LogInViewController? { get }
    func goToSignUp()
}

class LogInPresenter : LogInPresentable{
    
    // MARK: - Properties
    weak var view: LogInViewController?
    
    private let interactor: LogInInteractable
    private let router: LogInRouting
    
    // MARK: - Init
    init(interactor: LogInInteractable, router: LogInRouting) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Methods
    
    func goToSignUp() {
        router.showSignUp()
    }
    
}
