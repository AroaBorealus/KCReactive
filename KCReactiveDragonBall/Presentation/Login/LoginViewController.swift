//
//  LoginViewController.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import UIKit
import Combine

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let viewModel: LoginViewModel
    private var subscriptor = Set<AnyCancellable>()
    
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
    
    @IBAction private func onLoginButtonTapped(_ sender: UIButton) {
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
