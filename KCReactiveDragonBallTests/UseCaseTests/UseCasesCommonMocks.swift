//
//  UseCasesCommonMocks.swift
//  AppPatronesAroaTests
//
//  Created by Aroa Miguel Garcia on 6/10/24.
//

@testable import KCReactiveDragonBall
import XCTest

struct APISessionMockError: Error {
    let reason: String
}

final class APISessionMock: APISessionContract {
    let mockResponse: ((any APIRequest) -> Result<Data, APISessionMockError>)
    
    init(mockResponse: @escaping (any APIRequest) -> Result<Data, APISessionMockError>) {
        self.mockResponse = mockResponse
    }
    
    func request<Request: APIRequest>(apiRequest: Request) async throws -> Data {
        let result = mockResponse(apiRequest)
        switch result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}


final class DummySessionDataSource: SessionDataSourcesContract {
    
    private var mockSession: String?
    
    func getSession() -> String? {
        return mockSession
    }
    
    func hasSession() -> Bool {
        return mockSession != nil
    }
    
    func setSession(_ session: Data) {
        mockSession = String(decoding: session, as: UTF8.self)
    }
    
    func deleteSession() {
        mockSession = nil
    }
}

