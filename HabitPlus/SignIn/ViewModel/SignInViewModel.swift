//
//  SignInViewModel.swift
//  HabitPlus
//
//  Created by userext on 02/08/23.
//

import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    
    private var cancellable: AnyCancellable?
    private var cancellableRequest: AnyCancellable?
    
    private let publisher = PassthroughSubject<Bool, Never>()
    private let interactor: SignInInteractor
    
    @Published var uiState: SignInUIState = .none
    
    init(interactor: SignInInteractor) {
        self.interactor = interactor
        cancellable = publisher.sink { value in
            print("usuario criado! Go to home: ", value)
            
            if value {
                self.uiState = .goToHomeScreen
            }
        }
    }
    // Caso feche o app nao precisar renderizar mais as chamadas
    deinit {
        cancellable?.cancel()
        cancellableRequest?.cancel()
    }
    
    func login() {
        self.uiState = .loading
        
        cancellableRequest = interactor.login(loginRequest: SignInRequest(email: email,
                                                     password: password))
        .receive(on: DispatchQueue.main)
        
        // Observador que vai ser disparado sempre que o interactor trocar o estado do Future 
        .sink { completion in
            // Aqui é onde acontece o ERROR ou o FINISHED
            switch(completion) {
            case .failure(let appError):
                self.uiState = SignInUIState.error(appError.message)
                break
            case .finished:
                break
            }
        } receiveValue: { success in
            // Aqui acontece o SUCCESS
            let auth = UserAuth(idToken: success.accessToken,
                                refreshToken: success.refreshToken,
                                expires: Date().timeIntervalSince1970 + Double(success.expires), // horario na hora da autentificação + 3600seg
                                tokenType: success.tokenType)
            self.interactor.insertAuth(userAuth: auth)
            self.uiState = .goToHomeScreen
        }

        
        
//        interactor.login(loginRequest: SignInRequest(email: email,
//                                                     password: password)) { (successResponse, errorResponse) in
//            if let error = errorResponse {
//                DispatchQueue.main.async {
//                
//                    // Main Thread
//                }
//            }
//            if let success = successResponse {
//                DispatchQueue.main.async {
//                    
//                }
//            }
//        }
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

