//
//  ValidateManager.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 5/2/24.
//

import Foundation

final class ValidateManager {
    
    // MARK: - Properties
    static let shared = ValidateManager()
    
    // MARK: - Methods

    func validateName(nameUser: String? ) -> Bool {
        guard let name = nameUser else {
            return false
        }
        let newName = name.replacingOccurrences(of: " ", with: "")
        if newName.count > 0 {
            return true
        }else {
            return false
        }
       
    }
    
    func validateEmail(emailUser: String?) -> Bool {
        guard let email = emailUser else {
            return false
        }
        
        let regularExpresion = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@",regularExpresion)
        
        if !predicate.evaluate(with: email) {
            return false
        }else {
            return true
        }
    }
    
    func validatePassword(passwordUser: String?) -> Bool {
        guard let password = passwordUser else {
            return false
        }
        
        if contentDigit(value: password) &&
            contentLowerCase(value: password) &&
            contentUpperCase(value: password) &&
            contentSpecialCharacters(value: password) &&
            password.count >= 6 {
            return true
        }else {
            return false
        }
    }
    
    private func validateNumber(numberUser: String) -> Bool {
        if contentDigit(value: numberUser) && numberUser.count == 10 {
            return true
        }else {
            return false
        }
    }
    
    private func contentDigit(value: String) -> Bool{
        let regularExpresion = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@",regularExpresion)
        return predicate.evaluate(with: value)
    }
    
    private func contentLowerCase(value: String) -> Bool{
        let regularExpresion = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@",regularExpresion)
        return predicate.evaluate(with: value)
    }
    
    private func contentUpperCase(value: String) -> Bool{
        let regularExpresion = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@",regularExpresion)
        return predicate.evaluate(with: value)
    }
    
    private func contentSpecialCharacters(value: String) -> Bool{
        let regularExpresion = ".*[^A-Za-z0-9].*"
        let predicate = NSPredicate(format: "SELF MATCHES %@",regularExpresion)
        return predicate.evaluate(with: value)
    }
    
}
