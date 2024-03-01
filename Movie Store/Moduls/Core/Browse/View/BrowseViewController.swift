//
//  BrowseViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 21/2/24.
//

import UIKit
protocol BrowseView: AnyObject {
    func getMovies(movies: [DataMovie])
    func updateView(topRateMovie: [ItemModelCell], popularMovie: [ItemModelCell], upComing: [ItemModelCell], nowPlayingMovie: [ItemModelCell], topRateTV: [ItemModelCell], popularTV: [ItemModelCell], onAirTVModel: [ItemModelCell], airingTodayTvModel: [ItemModelCell] )
}

class BrowseViewController: UIViewController {

    // MARK: - Properties
    
    private let presenter: BrowserPresentable
    private var Loading: Bool = false
    
    var topRateModelArray: [ItemModelCell] = []
    var populaModelArray: [ItemModelCell] = []
    var upCominModelArray: [ItemModelCell] = []
    var nowPlayingModelArray: [ItemModelCell] = []
    
    var topRateTVArray: [ItemModelCell] = []
    var popularTvArray: [ItemModelCell] = []
    var onAirTVModel: [ItemModelCell] = []
    var airingTodayTvModel: [ItemModelCell] = []
    
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
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(240)), subitems: [item])
            
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(520)),
                subitems: [groupV]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
    
        case 2:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let groupH = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .absolute(410)),
                subitems: [item])

            let section = NSCollectionLayoutSection(group: groupH)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        case 3:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(240)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        case 4:
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
            
        case 5:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let groupH = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .absolute(410)),
                subitems: [item])

            let section = NSCollectionLayoutSection(group: groupH)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
        case 6:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(240)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
//        case 7:
//            let item = NSCollectionLayoutItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1),
//                    heightDimension: .fractionalHeight(1)
//                )
//            )
//            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(240)), subitems: [item])
//            
//            let section = NSCollectionLayoutSection(group: group)
//            section.orthogonalScrollingBehavior = .groupPaging
//            section.boundarySupplementaryItems = supplementaryView
//            return section
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

// MARK: - BrowseView
extension BrowseViewController: BrowseView {
    
    
    func updateView(topRateMovie: [ItemModelCell],
                    popularMovie: [ItemModelCell],
                    upComing: [ItemModelCell],
                    nowPlayingMovie: [ItemModelCell],
                    topRateTV: [ItemModelCell],
                    popularTV: [ItemModelCell],
                    onAirTVModel: [ItemModelCell],
                    airingTodayTvModel: [ItemModelCell]
    ) {
        DispatchQueue.main.async {
            self.topRateModelArray = topRateMovie
            self.populaModelArray = popularMovie
            self.upCominModelArray = upComing
            self.nowPlayingModelArray = nowPlayingMovie
            
            self.topRateTVArray = topRateTV
            self.popularTvArray = popularTV
            self.onAirTVModel = onAirTVModel
            self.airingTodayTvModel = airingTodayTvModel
            
            self.aCollectionView.reloadData()
        }
    }
    
    func getMovies(movies: [DataMovie]) {
        DispatchQueue.main.async {
//            self.dataMovies = movies
            self.aCollectionView.reloadData()
        }
    }
    

    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return presenter.populaMovieModel.count
        case 1:
            return presenter.topRateTVModel.count
        case 2:
            return presenter.topRateMovieModel.count
        case 3:
            return presenter.popularTVModel.count
        case 4:
            return presenter.upCominMovieModel.count
        case 5:
            return presenter.onAirTVModel.count
        case 6:
            return presenter.airingTodayTvModel.count
        default:
            return presenter.nowPlayingMovieModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.populaMovieModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.topRateTVModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.topRateMovieModel
            cell.configuration(model: movies[indexPath.row])
            return cell
            
        case 3:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.popularTVModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        case 4:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.upCominMovieModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        case 5:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.onAirTVModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        case 6:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.airingTodayTvModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            let movies = presenter.nowPlayingMovieModel
            cell.configuration(model: movies[indexPath.row])
            return cell
        }
        
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
            header.configure(with: "Popular Movies")
            return header
        case 1:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Top Rate TV Shows")
            return header
        case 2:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Top Rate Movies")
            return header
        case 3:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Popular TV Shows")
            return header
        case 4:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Up Coming Movies")
            return header
        case 5:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "On Air TV Shows")
            return header
        case 6:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Airing Today TV Shows")
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Now Playing Movies")
            return header
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        switch section {
            
        case 0:
            if indexPath.row == presenter.populaMovieModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .popularMovie)
                collectionView.reloadData()
            }
        case 1:
            if indexPath.row == presenter.topRateTVModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .topRateTV)
                collectionView.reloadData()
            }
        case 2:
            if indexPath.row == presenter.topRateMovieModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .topRateMovie)
                collectionView.reloadData()
            }
        case 3:
            if indexPath.row == presenter.popularTVModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .popularTV)
                collectionView.reloadData()
            }
        case 4:
            if indexPath.row == presenter.upCominMovieModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .upComingMovie)
                collectionView.reloadData()
            }
        case 5:
            if indexPath.row == presenter.onAirTVModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .onAirTV)
                collectionView.reloadData()
            }
        case 6:
            if indexPath.row == presenter.airingTodayTvModel.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .airingTV)
                collectionView.reloadData()
            }
        default:
            if indexPath.row == nowPlayingModelArray.count-1 {
                self.Loading = true
                presenter.validatePagesToDownloadData(option: .nowPlayingMovie)
                collectionView.reloadData()
            }
        }
    }
    
}
