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
    func reloadCell(index: Int)
    
    func showError(message: String)
    func hideError()
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
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .label
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private lazy var alertIcon: UIImageView = {
        var aView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100) )
        aView.image = UIImage(systemName: "exclamationmark.triangle")
        aView.contentMode = .scaleAspectFit
        aView.tintColor = .red
        aView.isHidden = true
        return aView
    }()
    
    private lazy var messageError: UILabel = {
        var aLable = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        aLable.text = "Ups, We have problems to connect"
        aLable.textColor = .secondaryLabel
        aLable.numberOfLines = 3
        aLable.textAlignment = .center
        aLable.isHidden = true
        aLable.font = .systemFont(ofSize: 20, weight: .bold)
        return aLable
    }()
    
    private lazy var tryAgainButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 60))
        button.setTitle("Try Again".uppercased(), for: .normal)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 12
        //        button.isEnabled = false
        button.isHidden = true
        button.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        return button
    }()
    
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
        
        presenter.reloadIfItNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        presenter.addItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        messageError.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 15 )//20
        tryAgainButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 + 50)
        alertIcon.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 90)
    }
    
    
    // MARK: - SetupView
    
    private func setUpView() {
        
        [aTableView, spinner, alertIcon, messageError, tryAgainButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            aTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 0),
            aTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                constant: 0),
            aTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                 constant: 0),
            aTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: 0),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    // MARK: - Methods

    @objc func tryAgain() {
        presenter.readItems()
    }
}

// MARK: - FavoriteView
extension FavoriteViewController: FavoriteView {
    func showError(message: String) {
        DispatchQueue.main.async {
            self.alertIcon.isHidden = false
            self.messageError.isHidden = false
            self.tryAgainButton.isHidden = false
            self.messageError.text = message
        }
    }
    
    func hideError() {
        DispatchQueue.main.async {
            self.alertIcon.isHidden = true
            self.messageError.isHidden = true
            self.tryAgainButton.isHidden = true
            self.messageError.text = ""
        }
    }
    
    func activateSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
    }
    
    func desactivateSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
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
    
    func reloadCell(index: Int) {
        DispatchQueue.main.async {
            self.items.remove(at: index)
            self.aTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteItem(index: indexPath.row)
        }
    }
    
    
}
