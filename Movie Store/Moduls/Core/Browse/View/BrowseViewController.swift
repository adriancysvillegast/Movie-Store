//
//  BrowseViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 21/2/24.
//

import UIKit
protocol BrowseView: AnyObject {
    func getMovies(movies: [DataMovie])
}

class BrowseViewController: UIViewController {

    // MARK: - Properties
    
    private let presenter: BrowserPresentable
    private var dataMovies: [DataMovie] = []
    
    private lazy var aCollectionView: UICollectionView = {
        let aCollection = UICollectionView(frame: .zero,
                                           collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sections, _ in
            return self.createSectionLayout(with: sections)
        }))
//        aCollection.backgroundColor = .systemBackground
        aCollection.delegate = self
        aCollection.dataSource = self
//        aCollection.isHidden = true
        aCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        return aCollection
    }()
    
    // MARK: - Init
    
    init(presenter: BrowserPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getMovies()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aCollectionView.frame = view.bounds
    }
    // MARK: - SetupView

    private func setUpView() {
        view.addSubview(aCollectionView)
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let groupH = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(250)), subitems: [item])

            let section = NSCollectionLayoutSection(group: groupH)
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            
            let groupVertical = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(400))
                ,subitem: item,
                count: 2
            )
            
            groupVertical.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(400)),
                subitem: groupVertical,
                count: 2)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
        
    }

}

// MARK: - BrowseView
extension BrowseViewController: BrowseView {
    func getMovies(movies: [DataMovie]) {
        DispatchQueue.main.async {
            self.dataMovies = movies
            self.aCollectionView.reloadData()
        }
    }
    

    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch dataMovies[section] {
        case .popular(let model):
            return model.count
        case .topRate(let model):
            return model.count
        case .nowPlaying(let model):
            return model.count
        case .upComing(let model):
            return model.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = dataMovies[indexPath.section]
        switch section {
        case .popular(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: model[indexPath.row])
            return cell
        case .topRate(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: model[indexPath.row])
            return cell
        case .nowPlaying(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: model[indexPath.row])
            return cell
        case .upComing(let model):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: model[indexPath.row])
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
            return UICollectionViewCell()
        }
        cell.configuration(model: topRate[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderReusableCellView.identifier,
            for: indexPath) as? HeaderReusableCellView else {
            return UICollectionReusableView()
        }
        header.configure(with: "Rate")
        return header
    }
}
