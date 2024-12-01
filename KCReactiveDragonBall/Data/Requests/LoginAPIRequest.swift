//
//  LoginAPIRequest.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

struct LoginAPIRequest: APIRequest {
    
    
    typealias Response = Data
    
    let headers: [String: String]
    let method: HTTPMethod = .POST
    let path: String = "/api/auth/login"
    
    init(credentials: Credentials) {
        let loginData = Data(String(format: "%@:%@", credentials.username, credentials.password).utf8)
        let base64String = loginData.base64EncodedString()
        headers = ["Authorization": "Basic \(base64String)"]
    }
}
