//
//  SplashViewModel.swift
//  HabitPlus
//
//  Created by userext on 27/07/23.
//

import SwiftUI
import Combine

class SplashViewModel: ObservableObject {
    
    @Published var uiState: SplashUIState = .loading
    
    private var cancellableAuth: AnyCancellable?
    private var cancellableRefresh: AnyCancellable?

    
    private let interactor: SplashInteractor
    
    init(interactor: SplashInteractor) {
        self.interactor = interactor
    }
    // Caso feche o app nao precisar renderizar mais as chamadas
    deinit {
        cancellableAuth?.cancel()
        cancellableRefresh?.cancel()
    }
    
    func onAppear() {
        cancellableAuth = interactor.fetchAuth()
            .delay(for: .seconds(2), scheduler: RunLoop.main) // delay antes de executar. RunLoop.main -> Rodar na tela principal
            .receive(on: DispatchQueue.main)
            .sink { userAuth in
                if userAuth == nil {  // Se userAuth == nulo -> login
                    self.uiState = .goToSignInScreen
                } else if (Date().timeIntervalSince1970 > Double(userAuth!.expires)) {  // senao Se userAuth != nulo && expirou
                    // horario atual > que horario na hora da autentificação + 3600seg
                    // chamar o refresh token na API
                    print("token expirou")
                    let request = RefreshRequest(token: userAuth!.refreshToken)
                    self.cancellableRefresh = self.interactor.refreshToken(refreshRequest: request)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            switch(completion) {
                            case .failure(_):
                                self.uiState = .goToSignInScreen
                            default:
                                break
                            }
                        }, receiveValue: { success in
                                let auth = UserAuth(idToken: success.accessToken,
                                                    refreshToken: success.refreshToken,
                                                    expires: Date().timeIntervalSince1970 + Double(success.expires), // horario na hora da autentificação + 3600seg
                                                    tokenType: success.tokenType)
                                
                                self.interactor.insertAuth(userAuth: auth)
                                self.uiState = .goToHomeScreen
                        })
                } else {  // senao -> ja esta autenticado -> tela principal
                    self.uiState = .goToHomeScreen
                }
            }
    }
}

extension SplashViewModel {
    func signInView() -> some View {
        return SplashViewRouter.makeSignInView()
    }
}
