//
//  SplashViewRouter.swift
//  HabitPlus
//
//  Created by userext on 02/08/23.
//

import SwiftUI

enum SplashViewRouter {
    
    static func makeSignInView() -> some View {
        let viewModel = SignInViewModel()
        return SignInView(viewModel: viewModel)
    }
    
}
