//
//  SplashViewModel.swift
//  HabitPlus
//
//  Created by userext on 27/07/23.
//

import SwiftUI

class SplashViewModel: ObservableObject {
    
    @Published var uiState: SplashUIState = .loading
    
    func onAppear() {
        //faz algo assincrono e muda o estado da uiState
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            //aqui é chamado depois de 3 segundos
            //self.uiState = .error("Erro na resposta do servidor")
            self.uiState = .goToSignInScreen
        }
    }
}

extension SplashViewModel {
    func signInView() -> some View {
        return SplashViewRouter.makeSignInView()
    }
}
