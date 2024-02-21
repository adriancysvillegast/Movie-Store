//
//  SignUpPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation


protocol SignUpPresentable: AnyObject {
    var view: SignUpView? { get }
    
    func signUpWasTapped(email: String?, name: String?, password: String?, passwordConf: String?)
    func validateValues(email: String?, name: String?, password: String?, passwordConf: String?) -> Bool
    func signUpUser(email: String, name: String, password: String, passwordConf: String)
}

class SignUpPresenter: SignUpPresentable {

    
    // MARK: - Properties
    
    weak var view: SignUpView?
    private let interactor: SignUpInteractable
    private var authManager: AuthManager
    
    init(interactor: SignUpInteractable, authManager: AuthManager = AuthManager()) {
        self.interactor = interactor
        self.authManager = authManager
    }
    
    
    // MARK: - Methods
    
    func signUpWasTapped(email: String?, name: String?, password: String?, passwordConf: String?) {
        if validateValues(email: email, name: name, password: password, passwordConf: passwordConf) {
            self.signUpUser(email: email!, name: name!, password: password!, passwordConf: passwordConf!)
        } else {
//            show error on view
            view?.showAlertWithErrorInValidation()
        }
    }
    
    func validateValues(email: String?, name: String?, password: String?, passwordConf: String?) -> Bool {
        guard let email = email, let name = name, let password = password, let passwordConf = passwordConf, password == passwordConf else {
            return false
        }

            if ValidateManager.shared.validateEmail(emailUser: email),
               ValidateManager.shared.validateName(nameUser: name),
               ValidateManager.shared.validatePassword(passwordUser: password) {
                return true
            } else {
                return false
            }
    }
    
    func signUpUser(email: String, name: String, password: String, passwordConf: String) {
        authManager.createNewUser(email: email, password: password, userName: name) { success in
            
            if success {
                self.view?.goToBrowser()
            }else {
                
            }
        }
    }
    
    
}
