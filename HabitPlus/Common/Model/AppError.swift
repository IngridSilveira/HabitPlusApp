//
//  AppError.swift
//  HabitPlus
//
//  Created by userext on 22/11/23.
//

import Foundation

enum AppError: Error {
    case response(message: String)
    
    public var message: String {
        switch self {
        case .response(let message):
            return message
        }
    }
}


/* Devolver as mensagens de erro */
