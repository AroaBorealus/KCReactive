//
//  NetworkRequestsTests.swift
//  KCReactiveDragonBallTests
//
//  Created by Aroa Miguel Garcia on 1/12/24.
//

@testable import KCReactiveDragonBall
import XCTest
import Combine

final class NetworkRequestsTests: XCTestCase {
    func test_LoginRequest() async {
        let credentials1 = Credentials(username: "Aroa", password: "Qwerty")
                
        let loginRequest = LoginAPIRequest(credentials: credentials1)
        XCTAssertNotNil(loginRequest)
        
        var constructedRequest: URLRequest
        
        do{
            try constructedRequest = loginRequest.getRequest()
            print("GetRequest: \(constructedRequest)")
        }catch{
            XCTFail("Request not constructed properly")
        }
    }
    
    func test_GetCharactersRequest() {
        
        let characterRequest = GetCharactersAPIRequest(characterName: "Aroa")
        XCTAssertNotNil(characterRequest)
        
        var constructedRequest: URLRequest
        
        do{
            try constructedRequest = characterRequest.getRequest()
            print("GetRequest: \(constructedRequest)")
        }catch{
            XCTFail("Request not constructed properly")
        }
    }
    
    func test_GetTransformationsRequest() {
        let transformationsRequest = GetTransformationsAPIRequest(characterId: "1234")
        XCTAssertNotNil(transformationsRequest)
        
        var constructedRequest: URLRequest
        
        do{
            try constructedRequest = transformationsRequest.getRequest()
            print("GetRequest: \(constructedRequest)")
        }catch{
            XCTFail("Request not constructed properly")
        }
    }
}
