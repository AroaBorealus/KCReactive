//
//  GetCharacterUseCase.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import Foundation

protocol GetCharacterUseCaseContract{
    func execute(_ characterName: String) async throws -> [DBCharacter]?
}


final class GetCharacterUseCase: GetCharacterUseCaseContract{
    func execute(_ characterName: String) async throws -> [DBCharacter]? {
        do {
            let character = try await GetCharactersAPIRequest(characterName: characterName).perform()
            return character
        } catch {
            throw GetCharacterUseCaseError(reason: "Use Case Failed")
        }
    }
}

struct GetCharacterUseCaseError: Error {
    let reason: String
}

