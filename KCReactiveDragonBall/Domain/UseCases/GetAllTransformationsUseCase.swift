//
//  GetAllTransformationsUseCase.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import Foundation

protocol GetAllTransformationsUseCaseContract{
    func execute(_ characterId: String) async throws -> [DBTransformation]?
}


final class GetAllTransformationsUseCase: GetAllTransformationsUseCaseContract{
    func execute(_ characterId: String) async throws -> [DBTransformation]?{
        do {
            let transformation = try await GetTransformationsAPIRequest(characterId: "\(characterId)").perform()
            return transformation
        } catch {
            throw GetAllTransformationsUseCaseError(reason: "Use Case Failed")
        }
    }
}

struct GetAllTransformationsUseCaseError: Error {
    let reason: String
}

