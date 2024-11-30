//
//  LoginViewModel.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 29/11/24.
//

import Foundation

enum LoginState: Equatable {
    case none
    case logging
    case error(reason: String)
    case ready
}

final class LoginViewModel {
    var useCase: LoginUseCaseContract
    @Published var loginState: LoginState
    
    init(_ useCase: LoginUseCaseContract){
        self.useCase = useCase
        self .loginState = .none
    }
    
    func login(_ username: String?, _ password: String?) async {
        self.loginState = .logging
        
        let credentials = Credentials(username: username ?? "", password: password ?? "")
        
        do {
            try await useCase.execute(credentials)
            self.loginState = .ready
        } catch let error as LoginUseCaseError {
            self.loginState = .error(reason: error.reason)
        } catch {
            self.loginState = .error(reason: "An login error has occurred")
        }
    }
}
