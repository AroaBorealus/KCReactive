//
//  DBUnit.swift
//  KCReactiveDragonBall
//
//  Created by Aroa Miguel Garcia on 28/11/24.
//

import Foundation

protocol DBUnit: Codable, Hashable{
    var name: String { get set }
    var photo: String { get set }
    var id: String { get set }
    var description: String { get set }
}
