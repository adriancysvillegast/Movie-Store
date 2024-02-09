//
//  SignUpRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation
import UIKit

protocol SignUpRouting: AnyObject {
    func showSignUp(fromVC: UIViewController)
}

class SignUpRouter: SignUpRouting {
    func showSignUp(fromVC: UIViewController) {
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter(interactor: interactor)
        let view = SignUpViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
    
}
