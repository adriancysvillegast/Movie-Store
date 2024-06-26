//
//  SignUpViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit

protocol SignUpView: AnyObject {
    func showAlertWithErrorInValidation()
    func activateButton()
    func desactivateButton()
    func showAlertWithErrorSignUp(title: String, message: String)
    func showTabBar()
}

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: SignUpPresentable
    
    private lazy var contentViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    
    private lazy var aScrollView: UIScrollView = {
        let aScrollView = UIScrollView(frame: .zero)
        aScrollView.frame = view.bounds
        aScrollView.contentSize = contentViewSize
        aScrollView.autoresizingMask = .flexibleHeight
        aScrollView.bounces = true
        aScrollView.isScrollEnabled = false
        aScrollView.backgroundColor = .clear
        return aScrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.frame.size = contentViewSize
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var aImageView: UIImageView = {
       let aImage = UIImageView()
        aImage.image = UIImage(named: "backgroundLogIn")
        aImage.contentMode = .scaleToFill
        return aImage
    }()
    
    private lazy var aOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
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
        view.addTarget(self, action: #selector(shouldActivateButton), for: .editingChanged)
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
        view.addTarget(self, action: #selector(shouldActivateButton), for: .editingChanged)
        view.delegate = self
        return view
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.textContentType = .newPassword
        view.autocorrectionType = .no
        view.placeholder = "Confirm Password".uppercased()
        view.borderStyle = .roundedRect
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(shouldActivateButton), for: .editingChanged)
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
        button.addTarget(self, action: #selector(signUpWasTapped), for: .touchUpInside)
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aImageView.frame =  view.bounds
        aOverlayView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - setUpView

    private func setUpView() {
        view.backgroundColor = .systemBackground
        [aImageView, aOverlayView, aScrollView].forEach {
            view.addSubview($0)
        }
        aScrollView.addSubview(containerView)
        
        
        [
            emailTextField, passwordTextField, confirmPasswordTextField, signUpButton, spinnerLoading
        ].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([

            emailTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,
                                                constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor,
                                                       constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),

            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor,
                                                constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.widthAnchor.constraint(equalToConstant: 120),

            spinnerLoading.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            spinnerLoading.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    
    // MARK: - targets
    
    @objc func signUpWasTapped() {
        presenter.signUpUser(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @objc func shouldActivateButton() {
        presenter.isEditingValues(email: emailTextField.text, password: passwordTextField.text, passwordConf: confirmPasswordTextField.text)
    }
    
    // MARK: - Methods
    

    
    
}

// MARK: - SignUpView

extension SignUpViewController: SignUpView {
    func showTabBar() {
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func activateButton() {
        DispatchQueue.main.async {
            self.signUpButton.isEnabled = true
            self.signUpButton.backgroundColor = .green
        }
    }
    
    func desactivateButton() {
        DispatchQueue.main.async {
            
        }
    }
    
    func showAlertWithErrorSignUp(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            self.present(alert, animated: true)
        }
        
    }
    
    func showAlertWithErrorInValidation() {
        let alert = UIAlertController(title: "Validation Error", message: "Try to add a correct email, name and password\nEmail must be in tihis format example@gmail.com\nName must have more than 3 characters\nPassword must have at leat 1 special character, 1 uppercase, 1 lowercase and 1 number ", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
}
// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        if textField == passwordTextField  {
            aScrollView.frame.origin.y -= 70
        } else if textField == emailTextField {
            aScrollView.frame.origin.y = 0
        } else if textField == confirmPasswordTextField {
            aScrollView.frame.origin.y -= 100
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        aScrollView.frame.origin.y = 0
    }
}
