//
//  SearchViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit


protocol SearchView: AnyObject {
    var presenter: SearchPresentable { get }
}

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: SearchPresentable
    
    // MARK: - Init
    init(presenter: SearchPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - SetupView
    
    
    // MARK: - Target
    
    // MARK: - Methods

}

// MARK: - SearchView

extension SearchViewController: SearchView {
    
}

