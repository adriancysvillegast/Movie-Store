//
//  LogInViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit

class LogInViewController: UIViewController {
    
    // MARK: - Properties
    let presenter: LogInPresenter
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.textContentType = .emailAddress
        view.placeholder = "Email".uppercased()
        view.borderStyle = .roundedRect
        view.tintColor = .red
        view.text = ""
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.textContentType = .newPassword
        view.autocorrectionType = .no
        view.placeholder = "Password".uppercased()
        view.borderStyle = .roundedRect
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In".uppercased(), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
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
    
    init(presenter: LogInPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - SetupView
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(goToSignUp))
        
        [emailTextField, passwordTextField, logInButton, spinnerLoading].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.widthAnchor.constraint(equalToConstant: 170),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinnerLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinnerLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    
    // MARK: - Targets
    @objc func emailValidate() {
        
    }
    
    @objc func passwordValidate() {
        
    }
    
    @objc func logInTapped() {
        
    }
    
    @objc func goToSignUp() {
        presenter.goToSignUp()
    }
    
    // MARK: - Methods
    
    
}


extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
