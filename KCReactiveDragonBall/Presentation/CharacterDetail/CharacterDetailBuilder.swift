//
//  CharacterDetailBuilder.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import UIKit

final class CharacterDetailBuilder {
    
    let characterInfo: CharacterInfo
    
    init(_ characterInfo: CharacterInfo) {
        self.characterInfo = characterInfo
    }
    
    func build() -> UIViewController{
        let characterUseCase = GetCharacterUseCase()
        let transformationsUseCase = GetAllTransformationsUseCase()
        let viewModel = CharacterDetailViewModel(characterUseCase, transformationsUseCase, characterInfo)
        let viewController = CharacterDetailViewController(viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
