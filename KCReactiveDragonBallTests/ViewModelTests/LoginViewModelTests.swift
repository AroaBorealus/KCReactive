//
//  LoginViewModelTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest
import Combine

private final class SuccessLoginUseCaseMock: LoginUseCaseContract {
    func execute(_ credentials: KCReactiveDragonBall.Credentials) async throws {
        return
    }
}
    
private final class FailedLoginUseCaseMock: LoginUseCaseContract {
    func execute(_ credentials: KCReactiveDragonBall.Credentials) async throws {
        throw LoginUseCaseError(reason: "Mocked error")
    }
}
    
    
final class LoginViewModelTests: XCTestCase {
    func test_login_success() async {
        let successExpectation = expectation(description: "Ready")
        let loggingxpectation = expectation(description: "Logging")
        let useCaseMock = SuccessLoginUseCaseMock()
        
        var subscriptor = Set<AnyCancellable>()
        
        let sut = LoginViewModel(useCaseMock)
        
        sut.$loginState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .logging:
                    loggingxpectation.fulfill()
                case .ready:
                    successExpectation.fulfill()
                case .error(reason: _):
                    XCTFail("El test falló debido a un error inesperado")
                case .none:
                    break
                }
            }
            .store(in: &subscriptor)
        
        Task {
            await sut.login("1234", "password")
        }
        
        await fulfillment(of: [loggingxpectation, successExpectation],timeout: 10)
    }
    
    func test_login_failure() async {
        let errorExpectation = expectation(description: "Error")
        let loggingxpectation = expectation(description: "Logging")
        let useCaseMock = FailedLoginUseCaseMock()
        
        var subscriptor = Set<AnyCancellable>()
        
        let sut = LoginViewModel(useCaseMock)
        
        sut.$loginState
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state{
                case .logging:
                    loggingxpectation.fulfill()
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
            await sut.login("1234", "password")
        }
        
        await fulfillment(of: [loggingxpectation, errorExpectation],timeout: 10)
    }
}
