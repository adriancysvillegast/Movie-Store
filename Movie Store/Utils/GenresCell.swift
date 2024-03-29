//
//  GenresCell.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 11/3/24.
//

import UIKit

class GenresCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "GenresCell"
    
    private lazy var nameGenre: UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 20, weight: .bold)
        name.numberOfLines = 2
        name.textAlignment = .center
//        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    // MARK: - SetUpView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [nameGenre].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2.0//1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemCyan

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameGenre.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameGenre.text = nil
    }
    
    // MARK: - configuration
    
    func configuration(model: GenresResponseEntity) {
        nameGenre.text = model.name
    }
}
