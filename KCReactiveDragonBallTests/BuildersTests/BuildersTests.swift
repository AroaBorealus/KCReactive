//
//  BuildersTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest


final class BuildersTests: XCTestCase {
    func test_SplashBuilder() {
        let splash = SplashBuilder().build()
        
        XCTAssertNotNil(splash)
    }
    
    func test_LoginBuilder() {
        let login = LoginBuilder().build()
        
        XCTAssertNotNil(login)
    }
    
    func test_HomeBuilder() {
        let home = HomeBuilder().build()
        
        XCTAssertNotNil(home)
    }
    
    func test_CharacterDetailBuilder() {
        let characterDetail = CharacterDetailBuilder(CharacterInfo(characterName: "Hola", characterId: "que tal")).build()
        
        XCTAssertNotNil(characterDetail)
    }
    
    func test_TransformationDetailBuilder() {
        let dbtransformation = DBTransformation(name: "1234",
                                                photo: "potato",
                                                id: "1",
                                                description: "",
                                                hero: [:])
        
        
        let transformationsDetail = TransformationDetailBuilder(dbtransformation).build()
        
        XCTAssertNotNil(transformationsDetail)
    }
}
