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
        WebService.login(request: SignInRequest(email: email,
                                                password: password)) { (successResponse, errorResponse) in
            if let error = errorResponse {
                DispatchQueue.main.async {
                    // Main Thread
                    self.uiState = .error(error.detail.message)
                }
            }
            if let success = successResponse {
                DispatchQueue.main.async {
                    print(success)
                    self.uiState = .goToHomeScreen
                }
            }
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

