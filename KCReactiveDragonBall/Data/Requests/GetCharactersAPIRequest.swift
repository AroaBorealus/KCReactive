//
//  GetCharactersAPIRequest.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 29/11/24.
//

import Foundation

struct GetCharactersAPIRequest: APIRequest {
    typealias Response = [DBCharacter]
    
    let method: HTTPMethod = .POST
    let path: String = "/api/heros/all"
    let body: (any Encodable)?
    
    init(characterName: String) {
        body = RequestEntity(name: characterName)
    }
}

private extension GetCharactersAPIRequest {
    struct RequestEntity: Encodable {
        let name: String
    }
}
