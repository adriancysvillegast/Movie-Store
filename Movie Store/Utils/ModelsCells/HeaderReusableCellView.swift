//
//  HeaderReusableCellView.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 22/2/24.
//

import UIKit

class HeaderReusableCellView: UICollectionReusableView {
    // MARK: - properties
    
    static let identifier = "HeaderReusableCellView"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - SetupView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: frame.width-30, height: frame.height)
    }
    
    // MARK: - Methods
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
