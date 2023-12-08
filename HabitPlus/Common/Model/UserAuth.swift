//
//  UserAuth.swift
//  HabitPlus
//
//  Created by userext on 27/11/23.
//

import Foundation


struct UserAuth: Codable {
    var idToken: String
    var refreshToken: String
    var expires: Double = 0.0
    var tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case idToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
        case tokenType = "token_type"
    }
}







// Sera encodable para encodar esse objeto, transformar de objeto para json para salvar ele no banco
// E tambem sera decodable, para decodificar o json de volta em objeto
// Codable - encapsula o encodable e decodable ao mesmo tempo
