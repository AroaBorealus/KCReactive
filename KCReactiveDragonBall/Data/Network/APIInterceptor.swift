//
//  APIInterceptor.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

protocol APIInterceptor { }

protocol APIRequestInterceptorContract: APIInterceptor {
    func intercept(request: inout URLRequest)
}

final class APIRequestAuthenticatorInterceptor: APIRequestInterceptorContract {
    
    func intercept(request: inout URLRequest) {
        guard let token = SessionDataSources.shared.getSession() else {
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    }
}
