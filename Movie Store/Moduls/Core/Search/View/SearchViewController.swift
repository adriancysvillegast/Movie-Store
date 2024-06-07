//
//  SearchViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit


protocol SearchView: AnyObject {
    var presenter: SearchPresentable { get }
    
    func showAlert(title: String, message: String)
    func showErrorLabel(text: String)
    func hideErrorLabel()
    func showGenres(movieItems: [GenreModelCell],
                    tvItems: [GenreModelCell]) 
    func showSpinner()
    func hideSpinner()
}

class SearchViewController: UIViewController {
    
    
    
    // MARK: - Properties
    var presenter: SearchPresentable
    
    private var movieItems: [GenreModelCell] = []
    private var tvItems: [GenreModelCell] = []
    
    private lazy var aSearchBar: UISearchController = {
        let aSearchBar = UISearchController()
        aSearchBar.delegate = self
        aSearchBar.searchBar.placeholder = "Movies, Tv Series and More"
        aSearchBar.definesPresentationContext = true
        aSearchBar.searchResultsUpdater = self
        return aSearchBar
    }()
    
    lazy var textError: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aCollectionView: UICollectionView = {
        let aCollection = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(
                sectionProvider: { sections, _ in
                return self.createSectionLayout(with: sections)
            }))
        //        aCollection.backgroundColor = .systemBackground
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.isHidden = true
        aCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        aCollection.register(GenresCell.self, forCellWithReuseIdentifier: GenresCell.identifier)
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
    
    // MARK: - Init
    init(presenter: SearchPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        aCollectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        presenter.showGenres()
    }
    
    // MARK: - SetupView
    
    private func setUpView() {
        
        view.backgroundColor = .systemBackground
        navigationItem.searchController = aSearchBar
        
        [aCollectionView, textError, spinner].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textError.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textError.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            textError.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            textError.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Target
    
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(250)),
                subitems: [groupV]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        case 1:
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(250)),
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

// MARK: - SearchView

extension SearchViewController: SearchView {
    
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
    
    func showErrorLabel(text: String) {
        DispatchQueue.main.async {
            self.textError.text = text
            self.textError.isHidden = false
        }
    }
    
    func hideErrorLabel() {
        DispatchQueue.main.async {
            self.textError.isHidden = true
        }
    }
    
    func showGenres(movieItems: [GenreModelCell],
                    tvItems: [GenreModelCell]) {
        DispatchQueue.main.async {
            self.movieItems = movieItems
            self.tvItems = tvItems
            self.aCollectionView.reloadData()
            self.aCollectionView.isHidden = false
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    
}

// MARK: - SearchBarDelegate

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.getQuery(query: searchBar.text)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return movieItems.count
        default:
            return tvItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as? GenresCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: movieItems[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as? GenresCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: tvItems[indexPath.row])
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = indexPath.section
        switch section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Movie Categories")
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "TV Categories")
            return header
        }
    }
    
}