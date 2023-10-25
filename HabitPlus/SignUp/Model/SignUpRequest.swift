//
//  SignUpRequest.swift
//  HabitPlus
//
//  Created by userext on 05/10/23.
//

import Foundation

struct SignUpRequest: Encodable {
    //    "name": fullName,
    //    "email": email,
    //    "document": document,
    //    "phone": phone,
    //    "gender": gender,
    //    "birthday": birthday,
    //    "password": password
    let fullName: String
    let email: String
    let password: String
    let document: String
    let phone: String
    let birthday: String
    let gender: Int
    
    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case email
        case password
        case document
        case phone
        case birthday
        case gender
    }
}
