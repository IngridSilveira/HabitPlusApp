//
//  ErrorResponse.swift
//  HabitPlus
//
//  Created by userext on 31/10/23.
//

import Foundation

struct ErrorResponse: Decodable {
    let detail: String
    
    enum CodingKeys: String, CodingKey {
        case detail
    }
}
