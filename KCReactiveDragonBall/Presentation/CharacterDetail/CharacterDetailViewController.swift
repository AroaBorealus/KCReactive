//
//  CharacterDetailViewController.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import UIKit
import Combine

class CharacterDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let viewModel: CharacterDetailModel
    private var subscriptor = Set<AnyCancellable>()
    
    @IBOutlet weak var characterImage: AsyncImageView!
    @IBOutlet weak var characterDescription: UILabel!
    @IBOutlet weak var errorStackView: UIStackView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    init(_ viewModel: CharacterDetailModel) {
        self.viewModel = viewModel
        super.init(nibName: "CharacterDetailView", bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TransformationsCollectionViewCell.nib, forCellWithReuseIdentifier: TransformationsCollectionViewCell.reuseIdentifier)
        
        bind()

        title = "Detail"
        Task {
            await viewModel.load()
        }
    }

    func bind(){
        viewModel.$character
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadCharacter()
            }
            .store(in: &subscriptor)
        
        viewModel.$transformations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &subscriptor)
        
        viewModel.$detailState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.stateChanged(state)
            }
            .store(in: &subscriptor)
    }
    
    func stateChanged(_ currentState: CharacterDetailStates) {
        switch currentState{
        case .loading:
            caseLoading()
        case .ready:
            caseReady()
        case .error(let reason):
            caseError(reason)
        case .none:
            break
        }
    }
    
    private func caseLoading() {
        activityIndicator.startAnimating()
        characterImage.isHidden = true
        characterDescription.isHidden = true
        errorStackView.isHidden = true
    }
    
    private func caseReady() {
        activityIndicator.stopAnimating()
        characterImage.isHidden = false
        characterDescription.isHidden = false
    }
    
    private func caseError(_ reason: String) {
        activityIndicator.stopAnimating()
        errorStackView.isHidden = false
        errorLabel.text = reason
    }
    
    @IBAction func onRetryButtonTapped(_ sender: UIButton) {
        Task{
            await viewModel.load()
        }
    }
    
    func loadCharacter(){
        let currentCharacter = viewModel.character
        characterImage.setImage(currentCharacter.photo)
        characterDescription.text = currentCharacter.description
        
        title = currentCharacter.name
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationsCollectionViewCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? TransformationsCollectionViewCell {
            let transformation = viewModel.transformations[indexPath.row]
            cell.setImage(transformation.photo)
            cell.setName(transformation.name)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row < viewModel.transformations.count else {
            return
        }
        let transformationFound = viewModel.transformations[indexPath.row]
        print("Transformation found: \(transformationFound.name)")
        self.navigationController?.show(TransformationDetailBuilder(transformationFound).build(), sender: nil)
    }
    
}
