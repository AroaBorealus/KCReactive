//
//  LoginUseCase.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

protocol LoginUseCaseContract {
    func execute(_ credentials: Credentials) async throws
}

final class LoginUseCase: LoginUseCaseContract {
    private let sessionDataSource: SessionDataSourcesContract

    init(sessionDataSource: SessionDataSourcesContract = SessionDataSources()) {
        self.sessionDataSource = sessionDataSource
    }

    func execute(_ credentials: Credentials) async throws {
        sessionDataSource.deleteSession()

        guard validateUsername(credentials.username) else {
            throw LoginUseCaseError(reason: "Invalid username")
        }

        guard validatePassword(credentials.password) else {
            throw LoginUseCaseError(reason: "Invalid password")
        }

        do {
            let token = try await LoginAPIRequest(credentials: credentials).perform()
            sessionDataSource.setSession(token)
        } catch {
            throw LoginUseCaseError(reason: "Network failed")
        }
    }

    func validateUsername(_ username: String) -> Bool {
        return username.contains("@") && !username.isEmpty
    }

    func validatePassword(_ password: String) -> Bool {
        return password.count >= 5
    }
}

struct LoginUseCaseError: Error, Equatable {
    let reason: String
}
