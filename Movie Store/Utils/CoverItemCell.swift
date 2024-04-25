//
//  CoverItemCell.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import UIKit
import Kingfisher

class CoverItemCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "CoverItemCell"
    
    private lazy var aImageCover: UIImageView = {
        let aImage = UIImageView()
        aImage.contentMode = .scaleAspectFit
//        aImage.layer.cornerRadius = 12
        return aImage
    }()
    
    // MARK: - SetUpView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [aImageCover].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 2.0//1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        aImageCover.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aImageCover.image = nil
    }
    
    // MARK: - configuration
    
    func configuration(model: ItemModelCell) {
        aImageCover.kf.setImage(with: model.artWork)
    }
    
    func configuration(model: Companies) {
        aImageCover.kf.setImage(with: model.logoPath)
    }
}
