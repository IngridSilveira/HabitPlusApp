//
//  SignUpViewModel.swift
//  HabitPlus
//
//  Created by userext on 09/08/23.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var birthday: String = ""
    @Published var document: String = ""
    @Published var phone: String = ""
    @Published var gender = Gender.male
    
    var publisher: PassthroughSubject<Bool, Never>!
    
    private var cancellableSignUp: AnyCancellable?
    private var cancellableSignIn: AnyCancellable?
    
    @Published var uiState: SignUpUIState = .none
    
    private let interactor: SignUpInteractor
    
    // construtor com dependencia do interactor
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }
    
    deinit {
        cancellableSignIn?.cancel()
        cancellableSignUp?.cancel()
    }
    
    func signUp() {
        self.uiState = .loading
        
        // pegar a String -> dd/MM/yyyy -> Date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"
        
        let dateFormatted = formatter.date(from: birthday)
        // validar a data
        guard let dateFormatted = dateFormatted else {
            self.uiState = .error("Data inválida \(birthday)")
            return
        }
        // date -> yyyy-MM-dd -> String
        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.string(from: dateFormatted)
        
        // Main Thread
        let signUpRequest = SignUpRequest(fullName: fullName,
                                          email: email,
                                          password: password,
                                          document: document,
                                          phone: phone,
                                          birthday: birthday,
                                          gender: gender.index)
        
        cancellableSignUp = interactor.postUser(signUpRequest: signUpRequest)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch (completion) {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                    break
                case .finished:
                    break
                }
            } receiveValue: { created in
                // se tiver criado -> login
                if (created) {
                    // self pois estamos usando uma variavel interna
                    self.cancellableSignIn = self.interactor.login(signInRequest: SignInRequest(email: self.email, password: self.password))
                        .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch(completion) {
                            case .failure(let appError):
                                self.uiState = .error(appError.message)
                                break
                            case .finished:
                                break
                            }
                        } receiveValue: { success in
                            print(created)
                            
                            let auth = UserAuth(idToken: success.accessToken,
                                                refreshToken: success.refreshToken,
                                                expires: Date().timeIntervalSince1970 + Double(success.expires), // horario na hora da autentificação + 3600seg
                                                tokenType: success.tokenType)
                            self.interactor.insertAuth(userAuth: auth)
                            
                            self.publisher.send(created)
                            self.uiState = .success
                        }
                }
            }
    }
}


extension SignUpViewModel {
    func homeView() -> some View {
        return SignUpViewRouter.makeHomeView()
    }
}
