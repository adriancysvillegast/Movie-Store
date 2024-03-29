//
//  DescriptionView.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 11/3/24.
//

import UIKit

class DescriptionView: UIViewController {

    // MARK: - Properties
    private let textDescription: String
    
    private lazy var backView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissScreen))
        view.addGestureRecognizer(tap)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var container: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var overview: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 40
        label.font = .systemFont(ofSize: 20, weight: .light)
//        label.isHidden = false
        label.text = textDescription
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    

    init(textDescription: String) {
        self.textDescription = textDescription
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "x.circle"), style: .done, target: self, action: #selector(dismissScreen))]
        
        setUpView()
    }
    
    // MARK: - setUpView
    
    private func setUpView() {
        
        view.addSubview(backView)
        backView.addSubview(container)
        container.addSubview(overview)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            container.heightAnchor.constraint(equalToConstant: 400),
            
            
            overview.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            overview.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            overview.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            overview.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 20)
        ])
        
        view.backgroundColor = .clear
    }
    
    // MARK: - Targets
    
    @objc func dismissScreen() {
        dismiss(animated: true)
    }
}
