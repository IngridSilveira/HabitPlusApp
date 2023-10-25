//
//  SignUpUIState.swift
//  HabitPlus
//
//  Created by userext on 09/08/23.
//

import Foundation

enum SignUpUIState: Equatable {
    case none
    case loading
    case success
    case error(String)
}
