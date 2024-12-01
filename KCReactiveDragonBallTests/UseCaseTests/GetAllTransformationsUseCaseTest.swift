//
//  GetAllTransformationsUseCaseTest.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest

final class GetAllTransformationsUseCaseTest: XCTestCase{
    func test_getAllTransformations_success() async {
        let sut = GetAllTransformationsUseCase()
        
        let expectation = self.expectation(description: "TestSuccess")
        let expectedTransformations = [DBTransformation(name: "1234",
                                                photo: "potato",
                                                id: "",
                                                description: "",
                                                hero: [:])]
        var returnedTransformations: [DBTransformation] = []
        do {
            let encodedTransformations = try JSONEncoder().encode(expectedTransformations)
            APISession.shared = APISessionMock{ _ in .success(encodedTransformations) }

            returnedTransformations = try await sut.execute("Qwerty")!

            expectation.fulfill()
        } catch {
            XCTFail("El test falló debido a un error inesperado: \(error)")
        }
        
        
        await fulfillment(of: [expectation],timeout: 10)
        
        XCTAssertEqual(expectedTransformations, returnedTransformations)
    }
    
    func test_getAllTransformations_failure() async {
        let sut = GetAllTransformationsUseCase()
        
        let expectation = self.expectation(description: "TestFailed")
        var returnedTransformations: [DBTransformation] = []
        do {
            let error: APISessionMockError = .init(reason: "mockError")
            APISession.shared = APISessionMock{ _ in .failure(error) }

            returnedTransformations = try await sut.execute("Qwerty")!
            XCTFail("El test falló debido a un error inesperado: \(error)")
        } catch {
            expectation.fulfill()
        }
        
        
        await fulfillment(of: [expectation],timeout: 10)
        
        XCTAssertTrue(returnedTransformations.isEmpty)
    }
}
