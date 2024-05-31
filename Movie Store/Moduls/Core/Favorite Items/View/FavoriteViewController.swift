//
//  FavoriteViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 29/5/24.
//

import UIKit

protocol FavoriteView: AnyObject {
    func activateSpinner()
    func desactivateSpinner()
    func getItems(items: [DetailModelCell])
    func showAlert(title: String, message: String)
}

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    var presenter: FavoritePresentable
    var items: [DetailModelCell] = []
    
    private lazy var aTableView: UITableView = {
        let aTable = UITableView()
        aTable.delegate = self
        aTable.dataSource = self
        aTable.register(ItemsCartCell.self, forCellReuseIdentifier: ItemsCartCell.identifier)
        aTable.rowHeight = 110
        aTable.translatesAutoresizingMaskIntoConstraints = false
        return aTable
    }()
    
    private var spinnerLoading: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .label
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
//    private lazy var aView : UIView = {
//        let aView = UIView()
//        let aLabel = UILabel()
//        aLabel.text = "Add a Movie or Serie to Favorite typing '+' on the details view of it"
//        aLabel.textAlignment = .center
//        aLabel.textColor = .label
//        aLabel.font = .systemFont(ofSize: 20, weight: .bold)
//        aView.addSubview(aLabel)
//        aView.backgroundColor = .systemBackground
//        aView.isHidden = true
//        aView.translatesAutoresizingMaskIntoConstraints = false
//        return aView
//    }()
    
    // MARK: - Init
    
    init(presenter: FavoritePresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCicle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        presenter.addItems()
    }
    
    
    
    // MARK: - SetupView
    
    private func setUpView() {
        view.addSubview(aTableView)
        view.addSubview(spinnerLoading)
        NSLayoutConstraint.activate([
            aTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 0),
            aTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 0),
            aTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: 0),
            aTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: 0),

            spinnerLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    // MARK: - Methods
    

    private func refreshData() {
        presenter.getItems()
    }

}

// MARK: - FavoriteView
extension FavoriteViewController: FavoriteView {
    func activateSpinner() {
        DispatchQueue.main.async {
            self.spinnerLoading.isHidden = false
            self.spinnerLoading.startAnimating()
        }
    }
    
    func desactivateSpinner() {
        DispatchQueue.main.async {
            self.spinnerLoading.isHidden = true
            self.spinnerLoading.stopAnimating()
        }
    }
    
    func getItems(items: [DetailModelCell]) {
        DispatchQueue.main.async {
            if items.isEmpty {
                self.aTableView.isHidden = true
            }else {
                self.items = items
                self.aTableView.isHidden = false
                self.aTableView.reloadData()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsCartCell.identifier, for: indexPath) as? ItemsCartCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: items[indexPath.row])
        
        return cell
    }
    
    
    
}
