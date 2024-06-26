//
//  LogInViewController.swift
//  Movie Store
//
//  Created by Adriancys Jesus Villegas Toro on 4/2/24.
//

import UIKit

protocol LogInView: AnyObject {
    func showTabBar()
    func showError(title: String, message: String)
    func activateButton()
    func deactivateButton()
    
}

class LogInViewController: UIViewController {
    
    // MARK: - Properties
    private let presenter: LogInPresenter
    
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
        aImage.contentMode = .scaleAspectFill
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aImageView.frame = view.bounds
        aOverlayView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    // MARK: - SetupView
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(goToSignUp))
        
        
        [aImageView, aOverlayView, aScrollView].forEach {
            view.addSubview($0)
        }
        aScrollView.addSubview(containerView)
        
        [emailTextField, passwordTextField, logInButton, spinnerLoading].forEach {
            containerView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            logInButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            logInButton.widthAnchor.constraint(equalToConstant: 170),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinnerLoading.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            spinnerLoading.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            
        ])
    }
    
    
    // MARK: - Targets
    @objc func emailValidate() {
        presenter.activateButton(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc func passwordValidate() {
        presenter.activateButton(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc func logInTapped() {
        presenter.createAccount(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @objc func goToSignUp() {
        presenter.goToSignUp()
    }
    
    // MARK: - Methods
    
    
}

// MARK: - LogInView
extension LogInViewController: LogInView {
    func activateButton() {
        DispatchQueue.main.async {
            self.logInButton.isEnabled = true
            self.logInButton.backgroundColor = .green
        }
    }
    
    func deactivateButton() {
        DispatchQueue.main.async {
            self.logInButton.isEnabled = false
            self.logInButton.backgroundColor = .gray
        }
    }
    
    func showTabBar() {
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let vc = TabBarController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField  {
            aScrollView.frame.origin.y -= 200
        } else if textField == emailTextField {
            aScrollView.frame.origin.y -= 150
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        aScrollView.frame.origin.y = 0
    }
    
}
