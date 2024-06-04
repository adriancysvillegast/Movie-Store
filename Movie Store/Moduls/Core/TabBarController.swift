//
//  TabBarController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 30/4/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupVCs()
        // Do any additional setup after loading the view.
    }
    

    
    fileprivate func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {

        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.tintColor = .label
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

    func setupVCs() {
            viewControllers = [
                createNavController(for: BrowserRouter().showBrowser(), title: NSLocalizedString("Browse", comment: ""), image: UIImage(systemName: "house")!),
                createNavController(for: FavoriteRouter().showFavoriteFromTabBar(), title: NSLocalizedString("Favorite", comment: ""), image: UIImage(systemName: "bookmark")!),
                createNavController(for: CartRouter().showCartFromTabBar(), title: NSLocalizedString("Cart", comment: ""), image: UIImage(systemName: "cart")!)
                
            ]
        }

}
