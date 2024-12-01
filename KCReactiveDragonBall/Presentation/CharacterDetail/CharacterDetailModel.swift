//
//  CharacterDetailModel.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import Foundation

//struct CharacterDetailInfo: Equatable{ //Usaremos esta información para enseñar o no el botón de Transformaciones en la vista
//    var character: DBCharacter
//    var hasTransformations: Bool = false
//}

enum CharacterDetailStates: Equatable {
    case loading
    case ready
    case error(reason: String)
    case none
}

final class CharacterDetailModel {
    let characterUseCase: GetCharacterUseCaseContract
    let transformationsUseCase: GetAllTransformationsUseCaseContract
    let characterInfo: CharacterInfo
    @Published var detailState: CharacterDetailStates
    @Published var character = DBCharacter()
    @Published var transformations: [DBTransformation] = []
    
    
    init(_ characterUseCase: GetCharacterUseCaseContract,_ transformationsUseCase: GetAllTransformationsUseCaseContract, _ characterInfo: CharacterInfo) {
        self.detailState = .none
        self.characterUseCase = characterUseCase
        self.transformationsUseCase = transformationsUseCase
        self.characterInfo = characterInfo
    }
    
    func load() async{
        self.detailState = .loading
        
        do {
            let apiCharacters = try await characterUseCase.execute(characterInfo.characterName)
            guard let characters = apiCharacters, !characters.isEmpty else {
                throw GetAllCharactersUseCaseError(reason: "Character array found empty")
            }
            
            guard let foundCharacter = characters.first(where: { candidate in
                return candidate.id == characterInfo.characterId
            }) else{
                self.detailState = .error(reason: "Character not found by ID")
                return
            }
            self.character = foundCharacter
            
            do {
                let apiTransformations = try await transformationsUseCase.execute(foundCharacter.id)
                guard let transformations = apiTransformations, !characters.isEmpty else {
                    throw GetAllCharactersUseCaseError(reason: "Character array found empty")
                }
                
                self.transformations = transformations
                
                self.detailState = .ready
            } catch let error as GetAllTransformationsUseCaseError {
                self.detailState = .error(reason: error.reason)
            } catch {
                self.detailState = .error(reason: "A transformations error has occurred")
            }
            
        } catch let error as GetCharacterUseCaseError {
            self.detailState = .error(reason: error.reason)
        } catch {
            self.detailState = .error(reason: "A detail error has occurred")
        }
    }
}
