//
//  APISession.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

protocol APISessionContract {
    func request<Request: APIRequest>(apiRequest: Request) async throws -> Data
}

struct APISession: APISessionContract {
    static var shared: APISessionContract = APISession()
    
    private let session = URLSession(configuration: .default)
    private let requestInterceptors: [APIRequestInterceptorContract]
    
    init(requestInterceptors: [APIRequestInterceptorContract] = [APIRequestAuthenticatorInterceptor()]) {
        self.requestInterceptors = requestInterceptors
    }
    
    func request<Request: APIRequest>(apiRequest: Request) async throws -> Data {
        do {
            // Construir y preparar la solicitud
            var request = try apiRequest.getRequest()
            requestInterceptors.forEach { $0.intercept(request: &request) }
            
            // Realizar la solicitud asincrónica
            let (data, response) = try await session.data(for: request)
            
            // Validar la respuesta HTTP
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIErrorResponse.network(apiRequest.path)
            }
            
            // Retornar los datos obtenidos
            return data
        } catch {
            throw error
        }
    }
}
