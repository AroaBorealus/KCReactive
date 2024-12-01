//
//  HomeViewModelTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest
import Combine

private final class SuccessGetCharactersUseCaseMock: GetAllCharactersUseCaseContract {
    func execute() async throws -> [KCReactiveDragonBall.DBCharacter]? {
        let characters = [KCReactiveDragonBall.DBCharacter(name: "1234",
                                                          photo: "potato",
                                                          id: "",
                                                          description: "",
                                                   favorite: false)]
        return characters
    }
}

private final class FailedGetCharactersUseCaseMock: GetAllCharactersUseCaseContract {
    func execute() async throws -> [KCReactiveDragonBall.DBCharacter]? {
        throw GetCharacterUseCaseError(reason: "Mocked error")
    }
}

final class HomeViewModelTests: XCTestCase{
    func test_home_success() async {
        let readyExpectation = expectation(description: "Ready")
        let loadingxpectation = expectation(description: "Loading")
        let useCaseMock = SuccessGetCharactersUseCaseMock()
        
        var subscriptor = Set<AnyCancellable>()
        
        let sut = HomeViewModel(useCaseMock)
        
        sut.$homeState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .loading:
                    loadingxpectation.fulfill()
                case .ready:
                    readyExpectation.fulfill()
                case .logout:
                    break
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
    
    func test_home_failure() async {
        let errorExpectation = expectation(description: "Error")
        let loadingxpectation = expectation(description: "Logging")
        let useCaseMock = FailedGetCharactersUseCaseMock()
        
        var subscriptor = Set<AnyCancellable>()
        
        let sut = HomeViewModel(useCaseMock)
        
        sut.$homeState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .loading:
                    loadingxpectation.fulfill()
                case .ready:
                    XCTFail("El test falló debido a un error inesperado")
                case .logout:
                    break
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
