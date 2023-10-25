//
//  SignUpViewRouter.swift
//  HabitPlus
//
//  Created by userext on 11/08/23.
//

import SwiftUI

enum SignUpViewRouter {
    static func makeHomeView() -> some View {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: viewModel)
    }
}
