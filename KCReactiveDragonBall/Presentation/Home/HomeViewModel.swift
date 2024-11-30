//
//  HomeViewModel.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 29/11/24.
//

import Foundation

enum HomeStates: Equatable {
    case loading
    case ready
    case error(reason: String)
    case logout
    case none
}

final class HomeViewModel {
    let useCase: GetAllCharactersUseCaseContract
    @Published var characters: [DBCharacter] = []
    @Published var homeState: HomeStates

    
    init(_ useCase: GetAllCharactersUseCaseContract) {
        self.useCase = useCase
        self.homeState = .none
    }
    
    func load() async {
        self.homeState = .loading
        do {
            let apiCharacters = try await useCase.execute()
            guard let characters = apiCharacters, !characters.isEmpty else {
                throw GetAllCharactersUseCaseError(reason: "Character array found empty")
            }
            
            self.characters = characters
            self.homeState = .ready
        } catch let error as GetAllCharactersUseCaseError {
            self.homeState = .error(reason: error.reason)
        } catch {
            self.homeState = .error(reason: "A home error has occurred")
        }
    }
    
    func logoutProcess(){
        SessionDataSources.shared.deleteSession()
        self.homeState = .logout
    }
}
