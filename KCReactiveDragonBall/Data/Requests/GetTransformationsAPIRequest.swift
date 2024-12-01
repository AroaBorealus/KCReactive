//
//  GetTransformationsAPIRequest.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 30/11/24.
//

import Foundation

struct GetTransformationsAPIRequest: APIRequest {
    typealias Response = [DBTransformation]
    
    let method: HTTPMethod = .POST
    let path: String = "/api/heros/tranformations"
    let body: (any Encodable)?
    
    init(characterId: String) {
        body = RequestEntity(id: characterId)
    }
}

private extension GetTransformationsAPIRequest {
    struct RequestEntity: Encodable {
        let id: String
    }
}

