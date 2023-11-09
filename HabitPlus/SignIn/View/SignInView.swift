//
//  SignInView.swift
//  HabitPlus
//
//  Created by userext on 02/08/23.
//

import SwiftUI

struct SignInView: View {
    
    @ObservedObject var viewModel: SignInViewModel
    
    @State var navigationHidden = true
    
    var body: some View {
        ZStack {
            if case SignInUIState.goToHomeScreen = viewModel.uiState {
                viewModel.homeView()
            } else {
                NavigationStack {
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(alignment: .center, spacing: 20) {
                            Spacer(minLength: 50)
                            
                            VStack(alignment: .center, spacing: 8) {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.horizontal, 78)
                                Spacer(minLength: 20)
                                Text("Login")
                                    .foregroundColor(.orange)
                                    .font(Font.system(.title).bold())
                                    .padding(.bottom, 8)
                                emailField
                                passwordField
                                enterButton
                                registerLink
                                Text("Copyright @Nenenxinha")
                                    .foregroundColor(Color.gray)
                                    .font(Font.system(size: 16).bold())
                                    .padding(.top, 16)
                            }
                        }
                        if case SignInUIState.error(let value) = viewModel.uiState {
                            Text("")
                                .alert(isPresented: .constant(true)) {
                                    Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("Ok")))
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 32)
                    .ignoresSafeArea()
                    .navigationBarTitle("Login", displayMode: .inline)
                    .navigationBarHidden(navigationHidden)
                }
            }
        }
    }
}

extension SignInView {
    var emailField: some View {
        //        TextField(" Email", text: $viewModel.email)
        //            .border(Color.black)
        EditTextView(text: $viewModel.email,
                     placeholder:  "E-mail",
                     keyboard: .emailAddress,
                     error: "e-mail inválido",
                     failure: !viewModel.email.isEmail())
    }
}

extension SignInView {
    var passwordField: some View {
        EditTextView(text: $viewModel.password,
                     placeholder:  "Senha",
                     keyboard: .emailAddress,
                     error: "Senha deve ter ao menos 8 caracteres",
                     failure: viewModel.password.count < 8,
                     isSecure: true)
    }
}

extension SignInView {
    var enterButton: some View {
        LoadingButtonView(action: {
            viewModel.login()
        },
                          text: "Entrar",
                          showProgress: self.viewModel.uiState == SignInUIState.loading,
                          disabled: !viewModel.email.isEmail() || viewModel.password.count < 8)
    }
}

extension SignInView {
    var registerLink: some View {
        VStack {
            Text("Ainda não possui cadastro?")
                .foregroundColor(.gray)
                .padding(.top, 48)
            ZStack {
                NavigationLink {
                    viewModel.signUpView()
                } label: {
                    Text("Realize seu Cadastro")
                }
            }
        }
    }
}


struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            SignInView(viewModel: SignInViewModel())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .preferredColorScheme($0)
        }
    }
}
