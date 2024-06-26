//
//  CartViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/4/24.
//

import UIKit

protocol CartView: AnyObject {
    func showError(message: String)
    func hideError()
    func showAlert(title: String, message: String)
    func showItems(items: [DetailModelCell])
    func hideItems()
    func reloadCell(index: Int)
    func showSpinner()
    func hideSpinner()
    func showSuggestion(items: [ItemModelCell])
    func hideSuggestion()
}

class CartViewController: UIViewController {

    // MARK: - Properties
    
    private let presenter: CartPresentable
    
    private var items: [DetailModelCell] = []
    private var itemsSugguest: [ItemModelCell] = []
    
    private lazy var aTableView: UITableView = {
        let aTable = UITableView()
        aTable.delegate = self
        aTable.dataSource = self
        aTable.register(ItemsCartCell.self, forCellReuseIdentifier: ItemsCartCell.identifier)
        aTable.rowHeight = 110
        aTable.translatesAutoresizingMaskIntoConstraints = false
        return aTable
    }()
    
    private lazy var aCollectionView: UICollectionView = {
        let aCollection = UICollectionView(frame: .zero,
                                           collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sections, _ in
            return self.createSectionLayout(with: sections)
        }))
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.isHidden = true
        aCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        return aCollection
    }()
    
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .label
        spinner.isHidden = true
        spinner.stopAnimating()
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
        aLable.numberOfLines = 2
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
        button.isHidden = true
        button.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadCartPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageError.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 20 )
        tryAgainButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 + 50)
        alertIcon.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 90)
        aCollectionView.frame = view.bounds
    }
    // MARK: - SetUpView
    
    private func setUpView() {
        title = "Cart"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        [aTableView, spinner, messageError, tryAgainButton, alertIcon, aCollectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            aTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            aTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            aTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            aTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    // MARK: - Targets
    
    @objc func tryAgain() {
        presenter.readItemsOnDB()
    }
    
    // MARK: - Methods
    
    private func createSectionLayout(with section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
        ]
        
        switch section{
        case 0:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupV = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5)),
                repeatingSubitem: item, count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(520)),
                subitems: [groupV]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
        default :
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupV = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.5)),
                repeatingSubitem: item, count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(520)),
                subitems: [groupV]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
        }
        
    }
}


// MARK: - Extension - CartView

extension CartViewController: CartView {
    func hideItems() {
        DispatchQueue.main.async {
            self.aTableView.isHidden = true
        }
    }
    
    func showItems(items: [DetailModelCell]) {
        DispatchQueue.main.async {
            self.aTableView.isHidden = false
            self.items = items
            self.aTableView.reloadData()
        }
    }
    
    func hideSuggestion() {
        DispatchQueue.main.async {
            self.aCollectionView.isHidden = true
        }
    }
    
    
    func showSuggestion(items: [ItemModelCell]) {
        DispatchQueue.main.async {
            self.aCollectionView.isHidden = false
            self.itemsSugguest = items
            self.aCollectionView.reloadData()
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
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.alertIcon.isHidden = false
            self.messageError.isHidden = false
            self.tryAgainButton.isHidden = false
            self.messageError.text = message
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
            self.spinner.stopAnimating() 
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        presenter.itemSelected(with: item)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsSugguest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CoverItemCell.identifier,
            for: indexPath
        ) as? CoverItemCell else {
            return UICollectionViewCell()
        }
        cell.configuration(model: itemsSugguest[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderReusableCellView.identifier,
            for: indexPath) as? HeaderReusableCellView else {
            return UICollectionReusableView()
        }
        header.configure(with: presenter.titleGenre)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemsSugguest[indexPath.row]
        presenter.suggestionSelected(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
