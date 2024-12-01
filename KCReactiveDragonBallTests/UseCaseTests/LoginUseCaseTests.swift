//
//  LoginUseCaseTests.swift
//  AppPatronesAroaTests
//
//  Created by Aroa Miguel Garcia on 6/10/24.
//

@testable import KCReactiveDragonBall
import XCTest

final class LoginUseCaseTests: XCTestCase {
    func test_loginGetToken_success() async {
        let dataSource = DummySessionDataSource()
        let sut = LoginUseCase(sessionDataSource: dataSource)
        
        let expectedToken = "tokenTest"
        let data = Data(expectedToken.utf8)
        let expectation = self.expectation(description: "LoginUseCase Success")
        
        APISession.shared = APISessionMock { _ in .success(data) }
        
        do {
            try await sut.execute(Credentials(username: "a@b.es", password: "122345"))
            expectation.fulfill()
        } catch {
            XCTFail("El test falló debido a un error inesperado: \(error)")
        }
        
        await fulfillment(of: [expectation],timeout: 10)
        XCTAssertEqual(dataSource.getSession(), expectedToken)
    }
    
    func test_loginGetToken_failure() async {
        let dataSource = DummySessionDataSource()
        let sut = LoginUseCase(sessionDataSource: dataSource)
        
        let expectation = self.expectation(description: "LoginUseCase Success")
        
        let error: APISessionMockError = .init(reason: "mockError")

        APISession.shared = APISessionMock { _ in .failure(error) }
        
        do {
            try await sut.execute(Credentials(username: "a@b.es", password: "122345"))
            
            XCTFail("El test falló debido a un error inesperado: \(error)")
        } catch {
            expectation.fulfill()

        }
        
        await fulfillment(of: [expectation],timeout: 10)
        XCTAssertNil(dataSource.getSession())
    }
}
