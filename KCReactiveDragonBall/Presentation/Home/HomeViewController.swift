//
//  HomeViewController.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 29/11/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let viewModel: HomeViewModel
    private var subscriptor = Set<AnyCancellable>()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogoutButton()
        
        bind()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CharacterCollectionViewCell.nib, forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        
        title = "Home"
        Task {
            await viewModel.load()
        }
    }
    
    private func configureLogoutButton() {
        let logoutIcon = UIImage(systemName: "power")
        let logoutButton = UIBarButtonItem(image: logoutIcon, style: .plain, target: self, action: #selector(logoutButtonTapped))
        logoutButton.tintColor = .label
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func logoutButtonTapped() {
        viewModel.logoutProcess()
    }
    
    
    func bind(){
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptor)
        
        viewModel.$homeState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.stateChanged(state)
            }
            .store(in: &subscriptor)
    }
    
    func stateChanged(_ currentState: HomeStates) {
        switch currentState{
        case .loading:
            caseLoading()
        case .ready:
            caseReady()
        case .logout:
            caseLogout()
        case .error(let reason):
            caseError(reason)
        case .none:
            break
        }
    }
    
    private func caseLoading() {
        errorStackView.isHidden = true
        collectionView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func caseReady() {
        errorStackView.isHidden = true
        collectionView.isHidden = false
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
    
    private func caseLogout() {
        self.present(LoginBuilder().build(), animated: true)
    }
    
    private func caseError(_ reason: String) {
        errorStackView.isHidden = false
        collectionView.isHidden = true
        activityIndicator.stopAnimating()
        errorLabel.text = reason
    }
    
    @IBAction func onRetryButtonTapped(_ sender: UIButton) {
        Task {
            await viewModel.load()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.characters.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        90
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? CharacterCollectionViewCell {
            let character = viewModel.characters[indexPath.row]
            cell.setImage(character.photo)
            cell.setName(character.name)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row < viewModel.characters.count else {
            return
        }
        let characterFound = viewModel.characters[indexPath.row]
        print("Character found: \(characterFound.name)")
//        self.navigationController?.show(CharacterDetailBuilder(characterFound.id).build(), sender: nil)
    }
    
}

