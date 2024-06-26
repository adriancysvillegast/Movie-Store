//
//  BrowseViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 21/2/24.
//

import UIKit
protocol BrowseView: AnyObject {
    func updateView()
    
    func showSpinner()
    func hiddenSpinner()
    func hiddenError()
    func showError(message: String)
    func reloadTable()
    func goBackToLogIn()
    func showAlert(title: String, message: String)
    
}

class BrowseViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: BrowserPresentable
    private var loading: Bool = false
    
    private lazy var aCollectionView: UICollectionView = {
        let aCollection = UICollectionView(frame: .zero,
                                           collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { sections, _ in
            return self.createSectionLayout(with: sections)
        }))
        //        aCollection.backgroundColor = .systemBackground
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.isHidden = true
        aCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        return aCollection
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
        //        button.isEnabled = false
        button.isHidden = true
        button.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        return button
    }()
    
    private var spinnerLoading: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .systemRed
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
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
        alertIcon.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 90)
        aCollectionView.frame = view.bounds
        messageError.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 - 20 )
        tryAgainButton.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2 + 50)
        spinnerLoading.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
    }
    // MARK: - SetupView
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.setRightBarButton(
            UIBarButtonItem(image: UIImage(systemName: "person"),
                            style: .done,
                            target: self,
                            action: #selector(logOut)),
            animated: true)
        [aCollectionView,alertIcon, messageError, tryAgainButton, spinnerLoading].forEach {
            view.addSubview($0)
        }
    }
    
    @objc func tryAgain() {
        presenter.getMovies()
    }
    
    
    @objc func logOut() {
        
        let alert = UIAlertController(title: "Leave your Account", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log out", style: .default, handler: { _ in
            self.presenter.logOutAccount()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(500)),
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(500)),
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
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
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(240)), subitems: [item])
            
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
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(520)),
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
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    func goBackToLogIn() {
        self.navigationController?.dismiss(animated: true)
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.aCollectionView.reloadData()
        }
    }
    
    func updateView() {
        DispatchQueue.main.async {
            self.aCollectionView.reloadData()
            self.aCollectionView.isHidden = false
        }
    }
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.aCollectionView.isHidden = true
            self.spinnerLoading.isHidden = false
            self.spinnerLoading.startAnimating()
        }
    }
    
    func hiddenSpinner() {
        DispatchQueue.main.async {
            self.spinnerLoading.isHidden = true
            self.spinnerLoading.stopAnimating()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.aCollectionView.isHidden = true
            self.alertIcon.isHidden = false
            self.messageError.isHidden = false
            self.tryAgainButton.isHidden = false
            self.messageError.text = message
        }
    }
    
    func hiddenError() {
        DispatchQueue.main.async {
            self.alertIcon.isHidden = true
            self.messageError.isHidden = true
            self.tryAgainButton.isHidden = true
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            let movies = presenter.populaMovieModel
            presenter.getDetails(id: movies[indexPath.row].id, type: .movie)
        case 1:
            let tv = presenter.topRateTVModel
            presenter.getDetails(id: tv[indexPath.row].id, type: .tv)
        case 2:
            let movies = presenter.topRateMovieModel
            presenter.getDetails(id: movies[indexPath.row].id, type: .movie)
        case 3:
            let tv = presenter.popularTVModel
            presenter.getDetails(id: tv[indexPath.row].id, type: .tv)
        case 4:
            let movies = presenter.upCominMovieModel
            presenter.getDetails(id: movies[indexPath.row].id, type: .movie)
        case 5:
            let tv = presenter.onAirTVModel
            presenter.getDetails(id: tv[indexPath.row].id, type: .tv)
        case 6:
            let tv = presenter.airingTodayTvModel
            presenter.getDetails(id: tv[indexPath.row].id, type: .tv)
        default:
            let movies = presenter.nowPlayingMovieModel
            presenter.getDetails(id: movies[indexPath.row].id, type: .movie)
        }
    }

//
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        let section = indexPath.section
        switch section {

        case 0:
            if indexPath.row == presenter.populaMovieModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .popularMovie)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 1:

            if indexPath.row == presenter.topRateTVModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .topRateTV)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 2:
            if indexPath.row == presenter.topRateMovieModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .topRateMovie)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 3:
            if indexPath.row == presenter.popularTVModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .popularTV)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 4:
            if indexPath.row == presenter.upCominMovieModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .upComingMovie)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 5:
            if indexPath.row == presenter.onAirTVModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .onAirTV)
//                aCollectionView.reloadData()
                self.loading = false
            }
        case 6:
            if indexPath.row == presenter.airingTodayTvModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .airingTV)
//                aCollectionView.reloadData()
                self.loading = false
            }
        default:
            if indexPath.row == presenter.nowPlayingMovieModel.count-1 {
                guard !loading else { return }
                self.loading = true
                presenter.validatePagesToDownloadData(option: .nowPlayingMovie)
//                aCollectionView.reloadData()
                self.loading = false
            }
        }
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt")
    }
    
}
