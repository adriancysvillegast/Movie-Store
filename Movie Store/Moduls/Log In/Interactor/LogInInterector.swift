//
//  LogInInterector.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import Foundation

protocol LogInInteractable: AnyObject {
    var presenter: LogInPresentable? { get }
}

class LogInInterector: LogInInteractable {
    
    // MARK: - Properties
    
    weak var presenter: LogInPresentable?
    
    
}
