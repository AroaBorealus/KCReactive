//
//  LoginViewController.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import UIKit
import Combine
import CombineCocoa

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let viewModel: LoginViewModel
    private var subscriptor = Set<AnyCancellable>()
    private var currentUsername = ""
    private var currentPassword = ""
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    init(_ loginViewModel: LoginViewModel) {
        self.viewModel = loginViewModel
        super.init(nibName: "LoginView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        configureView()
        bind()
    }
    
    private func configureView(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.loginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.handlerLoginButton()
            })
            .store(in: &subscriptor)
        
        self.emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] username in
                if let username{
                    self?.currentUsername = username
                    self?.loginButton.isEnabled = username.count >= 5 && username.contains("@")
                }
            })
            .store(in: &subscriptor)
        
        self.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] password in
                if let password{
                    self?.currentPassword = password
                }
            })
            .store(in: &subscriptor)
    }
    
    private func bind(){
        viewModel.$loginState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.stateChanged(state)
            }
            .store(in: &subscriptor)
    }
    
    func stateChanged(_ currentState: LoginState) {
        switch currentState{
        case .logging:
            caseLogging()
        case .ready:
            caseReady()
        case .error(reason: let reason):
            caseError(reason)
        case .none:
            break
        }
    }
    
    private func caseLogging() {
        loginButton.isHidden = true
        activityIndicator.startAnimating()
        errorLabel.isHidden = true
    }
    
    private func caseReady() {
        loginButton.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.isHidden = true
        print("FUNCIONA")
        self.present(HomeBuilder().build(), animated: true)
    }
        
    private func caseError(_ reason: String) {
        loginButton.isHidden = false
        activityIndicator.stopAnimating()
        errorLabel.isHidden = false
        errorLabel.text = reason
    }
    
    private func handlerLoginButton(){
        Task {
            await viewModel.login(emailTextField.text, passwordTextField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder() //Cierra el teclado si está abierto
            Task {
                await viewModel.login(emailTextField.text, passwordTextField.text)
            }
            return true
        }
}
