//
//  CharacterDetailViewModel.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest
import Combine


private final class SuccessGetCharacterUseCaseMock: GetCharacterUseCaseContract {
    func execute(_ characterName: String) async throws -> [KCReactiveDragonBall.DBCharacter]? {
        let characters = [
            KCReactiveDragonBall.DBCharacter(name: "1234",
                                             photo: "potato",
                                             id: "1",
                                             description: "",
                                             favorite: false),
            KCReactiveDragonBall.DBCharacter(name: "1234",
                                             photo: "potato",
                                             id: "2",
                                             description: "",
                                             favorite: false)]
        return characters
    }
}

private final class FailedGetCharacterUseCaseMock: GetCharacterUseCaseContract {
    func execute(_ characterName: String) async throws -> [KCReactiveDragonBall.DBCharacter]? {
        throw GetCharacterUseCaseError(reason: "Mocked error")
    }
}


private final class SuccessGetTransformationsUseCaseMock: GetAllTransformationsUseCaseContract {
    func execute(_ characterId: String) async throws -> [KCReactiveDragonBall.DBTransformation]? {
        let transformations = [
            KCReactiveDragonBall.DBTransformation(name: "1234",
                                                  photo: "potato",
                                                  id: "1",
                                                  description: "",
                                                  hero: [:])]
        return transformations
    }
}

private final class FailedGetTransformationsUseCaseMock: GetAllTransformationsUseCaseContract {
    func execute(_ characterId: String) async throws -> [KCReactiveDragonBall.DBTransformation]? {
        throw GetAllTransformationsUseCaseError(reason: "Mocked error")
    }
}


final class CharacterDetailViewModelTests: XCTestCase{
    func test_detail_success() async {
        let readyExpectation = expectation(description: "Ready")
        let loadingxpectation = expectation(description: "Loading")
        let charactersUseCaseMock = SuccessGetCharacterUseCaseMock()
        let transformationsUseCaseMock = SuccessGetTransformationsUseCaseMock()
        
        var subscriptor = Set<AnyCancellable>()
        
        let sut = CharacterDetailViewModel(charactersUseCaseMock, transformationsUseCaseMock, CharacterInfo(characterName: "1234", characterId: "1"))
        
        sut.$detailState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .loading:
                    loadingxpectation.fulfill()
                case .ready:
                    readyExpectation.fulfill()
                case .error(reason: _):
                    XCTFail("El test falló debido a un error inesperado")
                case .none:
                    break
                }
            }
            .store(in: &subscriptor)
        
        Task {
            await sut.load()
        }
        
        await fulfillment(of: [loadingxpectation, readyExpectation],timeout: 10)
    }
    
    func test_detail_failure() async {
        let errorExpectation = expectation(description: "Error")
        let loadingxpectation = expectation(description: "Logging")
        let charactersUseCaseMock = FailedGetCharacterUseCaseMock()
        let transformationsUseCaseMock = FailedGetTransformationsUseCaseMock()

        var subscriptor = Set<AnyCancellable>()
        
        let sut = CharacterDetailViewModel(charactersUseCaseMock, transformationsUseCaseMock, CharacterInfo(characterName: "1234", characterId: "1"))
        
        sut.$detailState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .loading:
                    loadingxpectation.fulfill()
                case .ready:
                    XCTFail("El test falló debido a un error inesperado")
                case .error(reason: _):
                    errorExpectation.fulfill()
                case .none:
                    break
                }
            }
            .store(in: &subscriptor)
        
        Task {
            await sut.load()
        }
        
        await fulfillment(of: [loadingxpectation, errorExpectation],timeout: 10)
    }
}
