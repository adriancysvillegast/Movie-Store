//
//  SignUpPresenter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation


protocol SignUpPresentable: AnyObject {
    var view: SignUpViewController? { get }
}

class SignUpPresenter: SignUpPresentable {
    // MARK: - Properties
    
    weak var view: SignUpViewController?
    private let interactor: SignUpInteractable
    
    init(interactor: SignUpInteractable) {
        self.interactor = interactor
    }
    
    
    // MARK: - Methods
    
}
