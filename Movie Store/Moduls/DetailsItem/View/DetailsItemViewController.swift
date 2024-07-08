//
//  DetailsItemViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/3/24.
//

import UIKit
import Kingfisher

protocol DetailsItemView: AnyObject {
    func showSpinner()
    func hideSpiner()
    func showError(message: String)
    func hideError()
    
    func showTVDetail(item: DetailModelCell)
    func showMovieDetail(item: DetailModelCell)
    func showPerson(person: PersonModelCell)
}

class DetailsItemViewController: UIViewController {
    
    // MARK: - Properties
    
    let presenter: DetailsItemPresentable
    var hideItems: Bool = false
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 70 )
    
    private lazy var aScrollView: UIScrollView = {
        let aScrollView = UIScrollView(frame: .zero)
        aScrollView.frame = view.bounds
        aScrollView.contentSize = contentViewSize
        aScrollView.autoresizingMask = .flexibleHeight
        aScrollView.bounces = true
        aScrollView.backgroundColor = .systemBackground
        return aScrollView
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.frame.size = contentViewSize
        return view
    }()
    
    private lazy var aImageCover: UIImageView = {
        let aImage = UIImageView()
        aImage.contentMode = .scaleAspectFill
//        aImage.backgroundColor = .red
        aImage.layer.cornerRadius = 12
        aImage.layer.borderWidth = 2.0//1.0
        aImage.layer.borderColor = UIColor.clear.cgColor
        aImage.layer.masksToBounds = true
        aImage.isHidden = true
        aImage.translatesAutoresizingMaskIntoConstraints = false
        return aImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var adultIcon: UIImageView = {
        let aImage = UIImageView()
        aImage.contentMode = .scaleAspectFit //.scaleAspectFill
        aImage.image = UIImage(systemName: "18.circle")
        aImage.tintColor = .secondaryLabel
        aImage.isHidden = true
        aImage.translatesAutoresizingMaskIntoConstraints = false
        return aImage
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = .secondaryLabel
        spinner.isHidden = true
        return spinner
    }()
    
    private lazy var firstDayAir: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ocupation: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gender: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeOfBirth : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var birthdayDate : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deathDayDate : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var popularityPerson : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let view = UITextView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        view.isScrollEnabled = true
        view.font =  .systemFont(ofSize: 18, weight: .medium)
        view.textColor = .secondaryLabel
        view.isEditable = false
        view.delegate = self
        view.sizeToFit()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var aCollectionViewGenres: UICollectionView = {
        let aCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            self.createSectionLayout(with: section)
        }))
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.showsVerticalScrollIndicator = true
        aCollection.isHidden = true
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(GenresCell.self, forCellWithReuseIdentifier: GenresCell.identifier)
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        aCollection.translatesAutoresizingMaskIntoConstraints = false
        return aCollection
    }()
    
    var genres: [GenresResponseEntity] = []
    var companies: [Companies] = []
    
    private lazy var numberSeasons: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var votesCount: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textError: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 4
        label.isHidden = true
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    
    init(presenter: DetailsItemPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinner.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2 - 50)
        textError.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2 - 50)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getItem()
        setUpView()
    }
    
    // MARK: - setUpView
    
    private func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(aScrollView)
        aScrollView.addSubview(containerView)
        
        [aImageCover, titleLabel, adultIcon, spinner, firstDayAir, placeOfBirth, aCollectionViewGenres, numberSeasons, ocupation, gender, votesCount, textView, textError, birthdayDate, deathDayDate, popularityPerson
        ].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
//            IMAGES
            
            aImageCover.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            aImageCover.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            aImageCover.widthAnchor.constraint(equalToConstant: containerView.frame.width/1.8),
            aImageCover.heightAnchor.constraint(equalToConstant: containerView.frame.height/2.6 - 25),
            
            
//             TITLE
            titleLabel.topAnchor.constraint(equalTo: aImageCover.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            adultIcon.topAnchor.constraint(equalTo: aImageCover.bottomAnchor, constant: 10),
            adultIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2),
            adultIcon.heightAnchor.constraint(equalToConstant: 40),
            adultIcon.widthAnchor.constraint(equalToConstant: 40),
           
//            TEXT
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 110),
            
            
//            EXTRA PERSONS
            placeOfBirth.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            placeOfBirth.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            placeOfBirth.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            placeOfBirth.heightAnchor.constraint(equalToConstant: 40),
            
            ocupation.topAnchor.constraint(equalTo: placeOfBirth.bottomAnchor, constant: 10),
            ocupation.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ocupation.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ocupation.heightAnchor.constraint(equalToConstant: 40),
            
            gender.topAnchor.constraint(equalTo: ocupation.bottomAnchor, constant: 10),
            gender.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            gender.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            gender.heightAnchor.constraint(equalToConstant: 40),
            
            birthdayDate.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 10),
            birthdayDate.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            birthdayDate.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            birthdayDate.heightAnchor.constraint(equalToConstant: 40),
            
            deathDayDate.topAnchor.constraint(equalTo: birthdayDate.bottomAnchor, constant: 10),
            deathDayDate.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            deathDayDate.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            deathDayDate.heightAnchor.constraint(equalToConstant: 40),
            
            popularityPerson.topAnchor.constraint(equalTo: deathDayDate.bottomAnchor, constant: 10),
            popularityPerson.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            popularityPerson.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            popularityPerson.heightAnchor.constraint(equalToConstant: 40),
            
            
//            COLLECTIONVIEWS
            
            aCollectionViewGenres.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 5),
            aCollectionViewGenres.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            aCollectionViewGenres.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            aCollectionViewGenres.heightAnchor.constraint(equalToConstant: 300),
            
//            EXTRAS MOVIE AND TV
            firstDayAir.topAnchor.constraint(equalTo: aCollectionViewGenres.bottomAnchor, constant: 5),
            firstDayAir.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            numberSeasons.topAnchor.constraint(equalTo: firstDayAir.bottomAnchor, constant: 5),
            numberSeasons.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            votesCount.topAnchor.constraint(equalTo: numberSeasons.bottomAnchor, constant: 5),
            votesCount.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
 
        ])
    }
    
    // MARK: - Navigation bar
    
    private func navBar() {
        if hideItems {
            navigationItem.rightBarButtonItems = []
        }else {
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(systemName: "bag"), style: .done, target: self, action: #selector(buyMovie)),
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToSaved))
            ]
        }
        
    }
    
    
    // MARK: - Methods
    
    private func createSectionLayout(with section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryView = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(40)),
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
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(100)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        default:
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 5, trailing: 2)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(100)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryView
            return section
            
        }
        
    }
    
    
    // MARK: - Targets
    
    @objc func addToSaved() {
        presenter.addToFavorite(from: self)
    }
    
    @objc func buyMovie() {
        presenter.addToCart(from: self)
    }
    
   
}

// MARK: - DetailsItemView
extension DetailsItemViewController: DetailsItemView {
    
    
    func showSpinner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = false
            self.spinner.startAnimating()
        }
    }
    
    func hideSpiner() {
        DispatchQueue.main.async {
            self.spinner.isHidden = true
            self.spinner.stopAnimating()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.textError.text = message
            self.textError.isHidden = false
        }
    }
    
    func hideError() {
        DispatchQueue.main.async {
            self.textError.isHidden = true
        }
    }
    
    
    func showMovieDetail(item: DetailModelCell) {
        DispatchQueue.main.async {
            
            [
                self.aImageCover, self.titleLabel, self.votesCount, self.aCollectionViewGenres, self.textView
                
            ].forEach {
                $0.isHidden = false
            }
            let adult = item.adult ?? false
            self.adultIcon.isHidden = adult ? false : true
            self.aImageCover.kf.setImage(with: item.artwork)
            self.titleLabel.text = item.name
            self.textView.text = item.overview
            self.genres = item.genres ?? []
            self.companies = item.productionCompanies
            self.votesCount.text = "Total Votes: \(item.voteCount ?? 0)"
            self.aCollectionViewGenres.reloadData()
        }
    }
    
    func showTVDetail(item: DetailModelCell) {
        DispatchQueue.main.async {
            
            [
                self.aImageCover, self.titleLabel, self.votesCount, self.aCollectionViewGenres, self.firstDayAir, self.numberSeasons, self.textView
            ].forEach {
                $0.isHidden = false
            }
            
            let adult = item.adult ?? false
            self.adultIcon.isHidden = adult ? false : true
            self.aImageCover.kf.setImage(with: item.artwork)
            self.titleLabel.text = item.name
            self.textView.text = item.overview
            self.genres = item.genres ?? []
            
            self.firstDayAir.text = "On Air since: \(item.firstAirDate ?? "N/A" )"
            self.numberSeasons.text = "Number Seasons: \(item.numSeasons ?? 1)"
            self.companies = item.productionCompanies
            self.votesCount.text = "Total Votes: \(item.voteCount ?? 0)"
            
            self.aCollectionViewGenres.reloadData()
        }
    }
    
    func showPerson(person: PersonModelCell) {
        
        DispatchQueue.main.async {
            
            [self.aImageCover, self.titleLabel, self.placeOfBirth, self.ocupation, self.gender, self.textView, self.birthdayDate, self.deathDayDate, self.popularityPerson].forEach {
                $0.isHidden = false
            }
            
            
            self.aImageCover.kf.setImage(with: person.artWork)
            self.titleLabel.text = person.name
            self.placeOfBirth.text = "Placer of Birth:\n\(person.placeOfBirth)"
            self.ocupation.text = "Ocupation:\n\(person.ocupation)"
            self.gender.text = "Gender:\n\(person.gender)"
            self.textView.text = person.biography
            self.birthdayDate.text = "Birthday:\n\(person.birthday)"
            self.deathDayDate.text = "Death Day:\n\(person.deathDay ?? "N/A")"
            self.popularityPerson.text = "Popularity:\n\(person.popularity)"
        }
    }
}

extension DetailsItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return genres.count
            
        default:
            return companies.count
            
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
            header.configure(with: "Genres")
            return header
            
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Companies")
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as? GenresCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: genres[indexPath.row])
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: companies[indexPath.row])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        switch section {
        case 0:
            print(genres[indexPath.row])
        default:
            print(companies[indexPath.row])
        }
    }
    
}

// MARK: - UITextViewDelegate

extension DetailsItemViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
