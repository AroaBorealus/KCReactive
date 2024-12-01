//
//  DBCharacter.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

struct DBCharacter: DBUnit{
    var name: String
    var photo: String
    var id: String
    var description: String
    let favorite: Bool
    
    init(){
        self.name = ""
        self.photo = ""
        self.id = ""
        self.description = ""
        self.favorite = false
    }
}

struct CustomCodableCharacter: Codable {
    let nombreCompleto: String
    let fotoURL: String
    let id: String
    let descripcion: String
    let favorito: Bool
}


extension CustomCodableCharacter {
    enum CodingKeys: String, CodingKey {
        case nombreCompleto = "name"
        case fotoURL = "photo"
        case id = "id"
        case descripcion = "description"
        case favorito = "favorite"
    }
}
