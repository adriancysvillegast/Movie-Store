//
//  SignUpInteractor.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation

protocol SignUpInteractable: AnyObject {
    var presenter: SignUpPresentable? { get }
}

class SignUpInteractor: SignUpInteractable {
    // MARK: - Properties
    
    weak var presenter: SignUpPresentable?
    
    // MARK: - Methods
    
    
}
