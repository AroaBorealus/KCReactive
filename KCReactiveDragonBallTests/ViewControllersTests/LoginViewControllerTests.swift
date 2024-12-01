//
//  LoginViewControllerTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest

final class LoginViewControllerTests: XCTestCase{
    func test_LoginViewController_bind() {
        let loginViewController = LoginBuilder().build() as! LoginViewController
        
        loginViewController.bind()
        
        XCTAssertFalse(loginViewController.subscriptor.isEmpty)
    }
}
