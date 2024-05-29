//
//  FavoriteViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import UIKit

protocol FavoriteView: AnyObject {
    
}

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    var presenter: FavoritePresentable
    
    // MARK: - Init
    
    init(presenter: FavoritePresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Methods
    


}

// MARK: - FavoriteView
extension FavoriteViewController: FavoriteView {
    
}
