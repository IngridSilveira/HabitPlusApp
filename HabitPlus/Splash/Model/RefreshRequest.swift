//
//  RefreshRequest.swift
//  HabitPlus
//
//  Created by userext on 07/12/23.
//

import Foundation

// modelo de dados
struct RefreshRequest: Encodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "refresh_token"
    }
}
