//
//  SignUpInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation

protocol SignUpInteractable: AnyObject {
    var presenter: SignUpPresentable? { get }
    
    func validate(email: String?, password: String?, confiPassword: String?) -> Bool
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void)
}

class SignUpInteractor: SignUpInteractable {
    // MARK: - Properties
    
    weak var presenter: SignUpPresentable?
    var auth: AuthManager
    
    // MARK: - Init
    
    init(auth: AuthManager = AuthManager()) {
        self.auth = auth
    }
    
    // MARK: - Methods
    
    func validate(email: String?, password: String?, confiPassword: String?) -> Bool {
        guard let email = email,
                let password = password,
                let conf = confiPassword,
                password == conf else {
            return false
        }
        
        if ValidateManager.shared.validatePassword(passwordUser: password),
           ValidateManager.shared.validateEmail(emailUser: email) {
            return true
        }else {
            return false
        }
        
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void ) {
        auth.createNewUser(email: email, password: password) { success in
            completion(success)
        }
    }
}
