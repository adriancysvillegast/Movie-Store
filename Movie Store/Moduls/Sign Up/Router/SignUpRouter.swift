//
//  SignUpRouter.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation
import UIKit

protocol SignUpRouting: AnyObject {
    var viewSignUp: SignUpViewController? { get }
    var browser: BrowserRouting? { get }
    
    func showSignUp(fromVC: UIViewController)
    func showBrowser()
}

class SignUpRouter: SignUpRouting {
    
    var viewSignUp: SignUpViewController?
    var browser: BrowserRouting?
    
    func showSignUp(fromVC: UIViewController) {
        self.browser = BrowserRouter()
        
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter(interactor: interactor, router: self)
        let view = SignUpViewController(presenter: presenter)
        viewSignUp = view
        presenter.view = view
        interactor.presenter = presenter
        fromVC.navigationController?.pushViewController(view, animated: true)
    }
    
    func showBrowser() {
        guard let controller = viewSignUp else {
            return
        }
        browser?.showBrowser(fromVC: controller)
        
    }
    
}
