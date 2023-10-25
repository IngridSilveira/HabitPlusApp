//
//  SignInUIState.swift
//  HabitPlus
//
//  Created by userext on 08/08/23.
//

import Foundation

enum SignInUIState: Equatable {
    case none
    case loading
    case goToHomeScreen
    case error(String)
}
