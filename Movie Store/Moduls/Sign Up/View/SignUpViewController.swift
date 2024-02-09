//
//  SignUpViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: SignUpPresentable
    
    private lazy var userNameTextField: UITextField = {
        let view = UITextField()
        view.textContentType = .emailAddress
        view.placeholder = "User name".uppercased()
        view.borderStyle = .roundedRect
        view.tintColor = .red
        view.text = ""
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.textContentType = .emailAddress
        view.placeholder = "Email".uppercased()
        view.borderStyle = .roundedRect
        view.tintColor = .red
        view.text = ""
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
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
//        view.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.textContentType = .newPassword
        view.autocorrectionType = .no
        view.placeholder = "Comfirm Password".uppercased()
        view.borderStyle = .roundedRect
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up".uppercased(), for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
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
    
    init(presenter: SignUpPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    // MARK: - setUpView

    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        [
            userNameTextField, emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, spinnerLoading
        ].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                   constant: 30),
            userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            userNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor,
                                                constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,
                                                constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor,
                                                constant: 20),
            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            spinnerLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinnerLoading.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
