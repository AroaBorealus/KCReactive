//
//  GetAllCharactersUseCase.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 29/11/24.
//

import Foundation

protocol GetAllCharactersUseCaseContract {
    func execute() async throws -> [DBCharacter]?
}

final class GetAllCharactersUseCase: GetAllCharactersUseCaseContract {
    func execute() async throws -> [DBCharacter]? {
        do {
            let characters = try await GetCharactersAPIRequest(characterName: "").perform()
            return characters
        } catch {
            throw GetAllCharactersUseCaseError(reason: "Use Case Failed")
        }
    }
}

struct GetAllCharactersUseCaseError: Error {
    let reason: String
}


