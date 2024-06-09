//
//  ItemsCartCell.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 26/4/24.
//

import UIKit
import Kingfisher

class ItemsCartCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "ItemsCartCell"
    
    private lazy var aImageCover: UIImageView = {
        let aImage = UIImageView()
        aImage.contentMode = .scaleAspectFit //.scaleAspectFill
        aImage.layer.cornerRadius = 12
        aImage.layer.borderWidth = 2.0//1.0
        aImage.layer.borderColor = UIColor.clear.cgColor
        aImage.layer.masksToBounds = true
//        aImage.backgroundColor = .red
        aImage.translatesAutoresizingMaskIntoConstraints = false
        return aImage
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(aImageCover)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            aImageCover.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            aImageCover.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            aImageCover.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            aImageCover.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: aImageCover.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    
    func configure(with item: DetailModelCell) {
        aImageCover.kf.setImage(with: item.artwork)
        titleLabel.text = item.name
    }
    
    func configure(with item: ItemModelCell) {
        aImageCover.kf.setImage(with: item.artWork)
        titleLabel.text = item.title
    }
    

}
