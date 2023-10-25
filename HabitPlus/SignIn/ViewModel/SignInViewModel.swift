//
//  SignInViewModel.swift
//  HabitPlus
//
//  Created by userext on 02/08/23.
//

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    
    private var cancellable: AnyCancellable?
    private let publisher = PassthroughSubject<Bool, Never>()
    
    @Published var uiState: SignInUIState = .none
    
    @Published var email = ""
    @Published var password = ""

    
    init() {
        cancellable = publisher.sink { value in
            print("usuario criado! Go to home: ", value)
            
            if value {
                self.uiState = .goToHomeScreen
            }
        }
    }

    deinit {
        cancellable?.cancel()
    }
    
    func login() {
        self.uiState = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.uiState = .goToHomeScreen
        }
    }
}

extension SignInViewModel {
    func homeView() -> some View {
        return SignInViewRouter.makeHomeView()
    }
    func signUpView() -> some View {
        return SignInViewRouter.makeSignUpView(publisher: publisher)
    }
}

