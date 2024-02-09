//
//  LogInRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation
import UIKit

protocol LogInRouting: AnyObject{
    
    var logInView: LogInViewController? { get }
    var signUpRouter: SignUpRouting? { get }
    
    func showLogIn() -> UIViewController
    func showSignUp()
}

class LogInRouter: LogInRouting {
    
    var logInView: LogInViewController?
    var signUpRouter: SignUpRouting?
    
    func showLogIn() -> UIViewController {
        signUpRouter = SignUpRouter()
        
        let interactor = LogInInterector()
        let presenter = LogInPresenter(interactor: interactor, router: self)
        let view = LogInViewController(presenter: presenter)
        logInView = view
        presenter.view = view
        interactor.presenter = presenter
        return view
    }
    
    func showSignUp() {
        guard let fromViewControler = logInView else {
            return
        }
        signUpRouter?.showSignUp(fromVC: fromViewControler)
    }
    
}
