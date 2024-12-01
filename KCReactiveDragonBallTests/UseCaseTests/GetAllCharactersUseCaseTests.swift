//
//  GetAllCharactersUseCaseTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest

final class GetAllCharactersUseCaseTests: XCTestCase {
    func test_getAllCharacters_success() async {
        let sut = GetAllCharactersUseCase()
        
        let expectation = self.expectation(description: "TestSuccess")
        let expectedCharacters = [DBCharacter(name: "1234",
                                              photo: "potato",
                                              id: "",
                                              description: "",
                                              favorite: false)]
        var returnedCharacters: [DBCharacter] = []
        do {
            let encodedCharacters = try JSONEncoder().encode(expectedCharacters)
            APISession.shared = APISessionMock{ _ in .success(encodedCharacters) }

            returnedCharacters = try await sut.execute()!

            expectation.fulfill()
        } catch {
            XCTFail("El test falló debido a un error inesperado: \(error)")
        }
        
        
        await fulfillment(of: [expectation],timeout: 10)
        
        XCTAssertEqual(expectedCharacters, returnedCharacters)
    }
    
    func test_getAllCharacters_failure() async {
        let sut = GetAllCharactersUseCase()
        
        let expectation = self.expectation(description: "TestFailure")
        var returnedCharacters: [DBCharacter] = []
        do {
            let error: APISessionMockError = .init(reason: "mockError")
            APISession.shared = APISessionMock{ _ in .failure(error) }

            returnedCharacters = try await sut.execute()!

            XCTFail("El test falló debido a un error inesperado: \(error)")
        } catch {
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation],timeout: 10)
        
        XCTAssertEqual(returnedCharacters.count, 0)
    }
}
