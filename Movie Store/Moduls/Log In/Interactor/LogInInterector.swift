//
//  LogInInterector.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation

protocol LogInInteractable: AnyObject {
    var presenter: LogInPresentable? { get }
    
    func validateEmail(email: String?) -> Bool
    func validatePass(password: String?) -> Bool
    func logIn(email: String, password: String, complation: @escaping (Bool ) -> () )
    
}

class LogInInterector: LogInInteractable {

    // MARK: - Properties
    
    weak var presenter: LogInPresentable?
    private var authManager: AuthManager
    
    init(authManager: AuthManager = AuthManager()) {
        self.authManager = authManager
    }
    
    // MARK: - Methods
    
    
    func validateEmail(email: String?) -> Bool {
        if ValidateManager.shared.validateEmail(emailUser: email) {
            return true
        }else {
            return false
        }
    }
    
    func validatePass(password: String?) -> Bool {
        if ValidateManager.shared.validatePassword(passwordUser: password) {
            return true
        }else {
            return false
        }
    }

    func logIn(email: String, password: String, complation: @escaping (Bool) -> ()) {
        authManager.logIn(email: email, password: password) { success in
            complation(success)
        }
    }
    
}
