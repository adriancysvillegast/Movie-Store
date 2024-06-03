//
//  CartViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import UIKit


// MARK: - CartView
protocol CartView: AnyObject {
    func error(title: String, message: String)
    func success()
    func showItems(items: [DetailModelCell])
    func reloadCell(index: Int)
}


// MARK: - CartViewController

class CartViewController: UIViewController {

    
    // MARK: - Properties
    
    private let presenter: CartPresenter
    
    private var items: [DetailModelCell] = []
    
    private lazy var aTableView: UITableView = {
        let aTable = UITableView()
        aTable.delegate = self
        aTable.dataSource = self
        aTable.register(ItemsCartCell.self, forCellReuseIdentifier: ItemsCartCell.identifier)
        aTable.rowHeight = 110
        aTable.translatesAutoresizingMaskIntoConstraints = false
        return aTable
    }()
    
    
    // MARK: - Init
    
    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        presenter.addItemToCart()
    }
    
    // MARK: - SetUpView
    
    private func setUpView() {
        title = "Cart"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(aTableView)
        NSLayoutConstraint.activate([
            aTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            aTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            aTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Methods
    

}


// MARK: - Extension - CartView

extension CartViewController: CartView {
    func showItems(items: [DetailModelCell]) {
        DispatchQueue.main.async {
            self.items = items
            self.aTableView.reloadData()
            print("showItems running")
        }
    }
    
    func error(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    func success() {
        print(" Was success")
    }
    
    func reloadCell(index: Int) {
        DispatchQueue.main.async {
            self.items.remove(at: index)
            self.aTableView.reloadData()
        }
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ItemsCartCell.identifier,
            for: indexPath) as? ItemsCartCell else {
            return UITableViewCell()
        }
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            presenter.deleteItem(index: indexPath.row)
        }
    }
}
