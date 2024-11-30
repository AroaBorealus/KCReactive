//
//  SplashBuilder.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 13/11/24.
//

import UIKit
import Combine

class SplashViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: SplashViewModel
    private var subscriptor = Set<AnyCancellable>()

    init(_ splashViewModel: SplashViewModel) {
        self.viewModel = splashViewModel
        super.init(nibName: "SplashView", bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.load()
    }

    func bind(){
        viewModel.$splashState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.stateChanged(state)
            }
            .store(in: &subscriptor)
    }
    
    func stateChanged(_ currentState: SplashState) {
        switch currentState{
        case .loading:
            caseLoading()
        case .hasToken:
            caseHasToken()
        case .noToken:
            caseNoToken()
        case .none:
            break
        }
    }

    private func caseLoading() {
        activityIndicator.startAnimating()
    }

    private func caseHasToken() {
        activityIndicator.stopAnimating()
        self.present(LoginBuilder().build(), animated: true)
    }

    private func caseNoToken() {
        activityIndicator.stopAnimating()
        self.present(LoginBuilder().build(), animated: true)
    }
}
