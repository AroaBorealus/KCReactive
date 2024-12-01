//
//  APIInterceptor.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation
import KeychainSwift

protocol SessionDataSourcesContract {
    func getSession() -> String?
    func hasSession() -> Bool
    func setSession(_ session: Data)
    func deleteSession()
}

final class SessionDataSources: SessionDataSourcesContract {
    
    private let keychain  = KeychainSwift()
    
    static let shared: SessionDataSources = .init()
    
    func getSession() -> String?{
        keychain.get(Constants.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func hasSession() -> Bool{
        guard keychain.get(Constants.CONST_TOKEN_ID_KEYCHAIN) != nil else {
            return false
        }
        return true
    }
    
    func setSession(_ session: Data) {
        keychain.set(String(decoding: session, as: UTF8.self), forKey: Constants.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func deleteSession() {
        keychain.delete(Constants.CONST_TOKEN_ID_KEYCHAIN)
        
    }
}
