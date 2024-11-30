//
//  SplashBuilder.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 13/11/24.
//

import Foundation
import Combine

enum SplashState {
    case none
    case loading
    case hasToken
    case noToken
}

final class SplashViewModel: ObservableObject {
    @Published var splashState: SplashState
        
    init(){
        splashState = .none
    }
    
    func load(){
        self.splashState = .loading
        self.checkToken()
    }
    
    func checkToken() {
        self.splashState = SessionDataSources.shared.hasSession() ? .hasToken : .noToken
    }
}
