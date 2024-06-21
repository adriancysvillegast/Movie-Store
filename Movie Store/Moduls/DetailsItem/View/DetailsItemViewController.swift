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
    
    lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 300)
    
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
        aImage.contentMode = .scaleAspectFit //.scaleAspectFill
        aImage.layer.cornerRadius = 12
        aImage.layer.borderWidth = 2.0//1.0
        aImage.layer.borderColor = UIColor.clear.cgColor
        aImage.layer.masksToBounds = true
        aImage.isHidden = true
        aImage.translatesAutoresizingMaskIntoConstraints = false
        return aImage
    }()
    
    private lazy var personImage: UIImageView = {
        let aImage = UIImageView()
        aImage.contentMode = .scaleAspectFit //.scaleAspectFill
        aImage.layer.cornerRadius = 12
        aImage.layer.borderWidth = 2.0//1.0
        aImage.layer.borderColor = UIColor.clear.cgColor
        aImage.layer.masksToBounds = true
        aImage.clipsToBounds = true
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
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var gender: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
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
    
    private lazy var overview: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 10
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        label.textAlignment = .justified
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(showDescription))
        label.isUserInteractionEnabled =  true
        label.addGestureRecognizer(labelTap)
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
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.text = "Genres"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var descriptionItem: String = ""
    
    private lazy var aCollectionViewGenres: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let aCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.showsVerticalScrollIndicator = true
        aCollection.isHidden = true
        aCollection.register(HeaderReusableCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableCellView.identifier)
        aCollection.register(GenresCell.self, forCellWithReuseIdentifier: GenresCell.identifier)
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
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 2
        label.text = "Companies"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var aCollectionViewCompanies: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let aCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        aCollection.delegate = self
        aCollection.dataSource = self
        aCollection.register(CoverItemCell.self, forCellWithReuseIdentifier: CoverItemCell.identifier)
        aCollection.isHidden = true
        aCollection.translatesAutoresizingMaskIntoConstraints = false
        return aCollection
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
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
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
//        spinner.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
//        textError.center = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getItem()
        setUpView()
    }
    
    // MARK: - setUpView
    
    private func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
//        view.addSubview(aScrollView)
//        aScrollView.addSubview(containerView)

//        [aImageCover, titleLabel, adultIcon, spinner, firstDayAir, genresLabel, overview, aCollectionViewGenres, numberSeasons, companyLabel, aCollectionViewCompanies, votesCount
//        ].forEach {
//            containerView.addSubview($0)
//        }
        
    }
    
    private func personConstraints() {

        [personImage, titleLabel, placeOfBirth, ocupation, gender, textView, spinner, textError ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            personImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            personImage.widthAnchor.constraint(equalToConstant: view.frame.width/2.4),
            personImage.heightAnchor.constraint(equalToConstant: view.frame.height/3.5),
            
            titleLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 35),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            
            placeOfBirth.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 2),
            placeOfBirth.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            placeOfBirth.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            placeOfBirth.heightAnchor.constraint(equalToConstant: 30),

            ocupation.topAnchor.constraint(equalTo: placeOfBirth.bottomAnchor, constant: 2),
            ocupation.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ocupation.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            ocupation.heightAnchor.constraint(equalToConstant: 30),

            gender.topAnchor.constraint(equalTo: ocupation.bottomAnchor, constant: 2),
            gender.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            gender.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            gender.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0) 
        ])
        
    }
    
    private func movieAndTvConstraints() {
        
        view.addSubview(aScrollView)
        aScrollView.addSubview(containerView)

        [aImageCover, titleLabel, adultIcon, firstDayAir, genresLabel, overview, aCollectionViewGenres, numberSeasons, companyLabel, aCollectionViewCompanies, votesCount, spinner, textError
        ].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            aImageCover.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            aImageCover.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            aImageCover.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            aImageCover.heightAnchor.constraint(equalToConstant: 560),
            
            titleLabel.topAnchor.constraint(equalTo: aImageCover.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: view.frame.width-50),
            titleLabel.heightAnchor.constraint(equalToConstant: 60),
            
            adultIcon.topAnchor.constraint(equalTo: aImageCover.bottomAnchor, constant: 10),
            adultIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 2),
            adultIcon.heightAnchor.constraint(equalToConstant: 40),
            adultIcon.widthAnchor.constraint(equalToConstant: 40),
            
            firstDayAir.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            firstDayAir.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            overview.topAnchor.constraint(equalTo: firstDayAir.bottomAnchor, constant: 5),
            overview.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            overview.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            overview.heightAnchor.constraint(equalToConstant: 100),
            
            genresLabel.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 5),
            genresLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            aCollectionViewGenres.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 5),
            aCollectionViewGenres.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            aCollectionViewGenres.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            aCollectionViewGenres.heightAnchor.constraint(equalToConstant: 120),
            
            companyLabel.topAnchor.constraint(equalTo: aCollectionViewGenres.bottomAnchor, constant: 5),
            companyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            aCollectionViewCompanies.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 5),
            aCollectionViewCompanies.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            aCollectionViewCompanies.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            aCollectionViewCompanies.heightAnchor.constraint(equalToConstant: 120),
            
            numberSeasons.topAnchor.constraint(equalTo: aCollectionViewCompanies.bottomAnchor, constant: 5),
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
    
    
    
    // MARK: - Targets
    
    @objc func addToSaved() {
        presenter.addToFavorite(from: self)
    }
    
    @objc func buyMovie() {
        presenter.addToCart(from: self)
    }
    
    @objc func showDescription() {
        let view = DescriptionView(textDescription: descriptionItem)
        view.modalPresentationStyle = .overFullScreen
        present(view, animated: true)
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
            self.movieAndTvConstraints()

            [
                self.aImageCover, self.titleLabel, self.overview, self.votesCount, self.aCollectionViewGenres, self.aCollectionViewCompanies, self.genresLabel, self.companyLabel
                
            ].forEach {
                $0.isHidden = false
            }
            
            self.adultIcon.isHidden = item.adult ?? false
            self.aImageCover.kf.setImage(with: item.artwork)
            self.titleLabel.text = item.name
            self.overview.text = item.overview
            self.descriptionItem = item.overview
            self.genres = item.genres ?? []
            self.companies = item.productionCompanies
            self.votesCount.text = "Total Votes: \(item.voteCount ?? 0)"
            
            self.aCollectionViewGenres.reloadData()
            self.aCollectionViewCompanies.reloadData()
        }
    }
    
    func showTVDetail(item: DetailModelCell) {
        DispatchQueue.main.async {
            self.movieAndTvConstraints()
            
            [
                self.aImageCover, self.titleLabel, self.overview, self.votesCount, self.aCollectionViewGenres, self.aCollectionViewCompanies, self.firstDayAir, self.numberSeasons, self.genresLabel, self.companyLabel
            ].forEach {
                $0.isHidden = false
            }
            
            self.adultIcon.isHidden = item.adult ?? false
            self.aImageCover.kf.setImage(with: item.artwork)
            self.titleLabel.text = item.name
            self.overview.text = item.overview
            self.descriptionItem = item.overview
            self.genres = item.genres ?? []
            self.firstDayAir.text = "On Air since: \(item.firstAirDate ?? "N/A" )"
            self.numberSeasons.text = "Number Seasons: \(item.numSeasons ?? 1)"
            self.companies = item.productionCompanies
            self.votesCount.text = "Total Votes: \(item.voteCount ?? 0)"
            
            self.aCollectionViewGenres.reloadData()
            self.aCollectionViewCompanies.reloadData()
        }
    }
    
    func showPerson(person: PersonModelCell) {
        
        DispatchQueue.main.async {
            self.personConstraints()
            
            [self.personImage, self.titleLabel, self.placeOfBirth, self.ocupation, self.gender, self.textView].forEach {
                $0.isHidden = false
            }
            
            
            self.personImage.kf.setImage(with: person.artWork)
            self.titleLabel.text = person.name
            self.placeOfBirth.text = "Placer of Birth: \(person.placeOfBirth)"
            self.ocupation.text = "Ocupation: \(person.ocupation)"
            self.gender.text = "Gender: \(person.gender)"
            self.descriptionItem = person.biography
            self.textView.text = person.biography
            
        }
    }
}

extension DetailsItemViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case aCollectionViewCompanies:
            return companies.count
        case aCollectionViewGenres:
            return genres.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch collectionView {
        case aCollectionViewCompanies:
            
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Companies")
            return header
            
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderReusableCellView.identifier,
                for: indexPath) as? HeaderReusableCellView else {
                return UICollectionReusableView()
            }
            header.configure(with: "Genres")
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case aCollectionViewGenres:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenresCell.identifier, for: indexPath) as? GenresCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: genres[indexPath.row])
            return cell
        case aCollectionViewCompanies:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoverItemCell.identifier, for: indexPath) as? CoverItemCell else {
                return UICollectionViewCell()
            }
            cell.configuration(model: companies[indexPath.row])
            return cell
        default:
            let cell = UICollectionViewCell()
            cell.backgroundColor = .red
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case aCollectionViewGenres:
            return CGSize(width: 100, height: 100)
        case aCollectionViewCompanies:
            return CGSize(width: 150, height: 100)
        default:
            return CGSize(width: 200, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case aCollectionViewGenres:
            print(genres[indexPath.row])
        case aCollectionViewCompanies:
            print(companies[indexPath.row])
        default:
            print("----")
        }
    }
    
}

// MARK: - UITextViewDelegate

extension DetailsItemViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
}
