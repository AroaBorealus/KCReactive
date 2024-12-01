//
//  DetailViewControllerTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest

final class DetailViewControllerTests: XCTestCase{
    func test_CharacterDetailViewController_bind() {
        let characterDetail = CharacterDetailBuilder(CharacterInfo(characterName: "Hola", characterId: "que tal")).build() as! CharacterDetailViewController
        
        characterDetail.bind()
        
        XCTAssertFalse(characterDetail.subscriptor.isEmpty)
    }
}
