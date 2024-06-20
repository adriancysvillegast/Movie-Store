//
//  ListByGenreViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 10/6/24.
//

import UIKit

protocol ListByGenreView: AnyObject {
    
    func showItems(items: [ItemModelCell])
    func hideCollection()
    func addNext(items: [ItemModelCell])
    
    func showError(message: String)
    func hideError(message: String)
    func showAlert(title: String, message: String)
    
}

class ListByGenreViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: ListByGenrePresentable
    private var items: [ItemModelCell] = []
    private var loading: Bool = false
    
    private lazy var aCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 120)
        layout.scrollDirection = .vertical
        
        let aCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //        aCollection.backgroundColor = .systemBackground
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.isHidden = true
        aCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        aCollection.translatesAutoresizingMaskIntoConstraints = false
        return aCollection
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
    
    // MARK: - Init
    
    init(presenter: ListByGenrePresentable) {
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
        presenter.getItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    // MARK: - SetUpView
    private func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        [aCollectionView, messageError].forEach {
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            aCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            aCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            aCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            aCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Methods
    
    
    
}
// MARK: - ListByGenreView

extension ListByGenreViewController: ListByGenreView {
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func addNext(items: [ItemModelCell]) {
        DispatchQueue.main.async {
            
            self.items += items
            self.aCollectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            
            self.messageError.text = message
            self.messageError.isHidden = false
        }
    }
    
    func hideError(message: String) {
        DispatchQueue.main.async {
            
            self.messageError.isHidden = true
        }
    }
    
    func hideCollection() {
        DispatchQueue.main.async {
            
            self.aCollectionView.isHidden = true
        }
    }
    
    func showItems(items: [ItemModelCell]) {
        
        DispatchQueue.main.async {
            
            self.items = items
            self.aCollectionView.isHidden = false
            self.aCollectionView.reloadData()
        }
    }
    
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ListByGenreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
            return UICollectionViewCell()
        }
        cell.configuration(model: items[indexPath.row])
        //        cell.backgroundColor = .red
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2.11, height: view.frame.height/3.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 2 {
            guard !loading else { return }
            self.loading = true
            presenter.getNextPage()
            self.loading =  false
            
        }
    }
}
