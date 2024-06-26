//
//  SignUpPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation


protocol SignUpPresentable: AnyObject {
    var view: SignUpView? { get }
    
    func isEditingValues(email: String?, password: String?, passwordConf: String?)
    func signUpUser(email: String, password: String)
}

class SignUpPresenter: SignUpPresentable {

    
    // MARK: - Properties
    
    weak var view: SignUpView?
    private let interactor: SignUpInteractable
    private var authManager: AuthManager
    private let router: SignUpRouting
    
    init(interactor: SignUpInteractable,router: SignUpRouting, authManager: AuthManager = AuthManager()) {
        self.router = router
        self.interactor = interactor
        self.authManager = authManager
    }
    
    
    // MARK: - Methods
    
    func isEditingValues(email: String?, password: String?, passwordConf: String?) {
        if interactor.validate(email: email, password: password, confiPassword: passwordConf) {
            self.view?.activateButton()
        }else {
            self.view?.desactivateButton()
        }
    }
    

    
    func signUpUser(email: String, password: String) {
        
        interactor.signUp(email: email, password: password) { success in
            switch success {
                
            case true:
                self.view?.showTabBar()
            case false:
                self.view?.showAlertWithErrorSignUp(title: "Error", message: "Try to add a correct email, name and password\nEmail must be in tihis format example@gmail.com\nName must have more than 3 characters\nPassword must have at leat 1 special character, 1 uppercase, 1 lowercase and 1 number ")
            }
        }
    }
    
    
}
