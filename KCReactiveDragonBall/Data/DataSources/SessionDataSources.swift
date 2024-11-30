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
    
    private let kToken = "kToken"
    private let keychain  = KeychainSwift()
    
    static let shared: SessionDataSources = .init()
    
    func getSession() -> String?{
        keychain.get(kToken)
    }
    
    func hasSession() -> Bool{
        guard keychain.get("kToken") != nil else {
            return false
        }
        return true
    }
    
    func setSession(_ session: Data) {
        keychain.set(String(decoding: session, as: UTF8.self), forKey: kToken)
    }
    
    func deleteSession() {
        keychain.delete(kToken)
        
    }
}
