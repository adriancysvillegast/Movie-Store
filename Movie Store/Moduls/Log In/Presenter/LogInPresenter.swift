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
    func createAccount(email: String?, password: String?)
    func activateButton(email: String?, password: String?)
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
    
    func createAccount(email: String?, password: String?) {
        if interactor.validateEmail(email: email) &&
            ((password?.isEmpty) != nil) {
            
            guard let email = email, let password = password else { return }
            
            interactor.logIn(email: email, password: password) { result in
                if result {
//                    show home
                    self.view?.showTabBar()
                }else {
                    self.view?.showError(title: "Error", message: "We got and error trying to log in, try again.")
//                    show an error
                }
            }
            
        }else {
            
            view?.showError(title: "Error", message: "")
//            show error por los campos imcompletos
        }
    }
    
    
    
    func activateButton(email: String?, password: String?) {
        if interactor.validateEmail(email: email) &&
            ((password?.isEmpty) != nil) {
            view?.activateButton()
        }else {
            view?.deactivateButton()
        }
    }
}
