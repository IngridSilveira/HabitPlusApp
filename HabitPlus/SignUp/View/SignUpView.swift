 //
//  SignUpView.swift
//  HabitPlus
//
//  Created by userext on 09/08/23.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            VStack {
                Text("Cadastro")
                    .bold()
                    .font(.title3)
                    fullNameField
                    birthdayField
                    phoneField
                    documentField
                    emailField
                    passwordField
                Spacer()
                saveButton
            }.padding()
            if case SignUpUIState.error(let value) = viewModel.uiState {
                Text("")
                .alert(isPresented: .constant(true)) {
                    Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("Ok")))
                }
            }
        }
    }
}

extension SignUpView {
    var fullNameField: some View {
        EditTextView(text: $viewModel.fullName,
                     placeholder: "Nome Completo*",
                     keyboard: .alphabet,
                     error: "Nome inválido",
                     failure: viewModel.fullName.count < 3)
    }
}

extension SignUpView {
    var birthdayField: some View {
        EditTextView(text: $viewModel.birthday,
                     placeholder: "Nascimento*",
                     keyboard: .numberPad,
                     error: "Data deve ser dd/mm/yyyy",
                     failure: viewModel.birthday.count  != 10)
        // todo: mask
        // todo: isDisabled
    }
}

extension SignUpView {
    var phoneField: some View {
        EditTextView(text: $viewModel.phone,
                     placeholder: "Celular*",
                     keyboard: .numberPad,
                     error: "Entre com o DDD + 8 ou 9 digitos",
                     failure: viewModel.phone.count < 10 || viewModel.phone.count >= 12)
        // todo: mask
        // todo: isDisabled
    }
}

extension SignUpView {
    var emailField: some View {
        EditTextView(text: $viewModel.email,
                     placeholder:  "E-mail*",
                     keyboard: .emailAddress,
                     error: "e-mail inválido",
                     failure: !viewModel.email.isEmail())
    }
}

extension SignUpView {
    var passwordField: some View {
        EditTextView(text: $viewModel.password,
                     placeholder:  "Senha*",
                     keyboard: .emailAddress,
                     error: "Senha deve ter ao menos 8 caracteres",
                     failure: viewModel.password.count < 8,
                     isSecure: true)
    }
}

extension SignUpView {
    var documentField: some View {
        EditTextView(text: $viewModel.document,
                     placeholder: "CPF*",
                     keyboard: .numberPad,
                     error: "CPF Inválido",
                     failure: viewModel.document.count != 11)
        // todo: mask
        // todo: isDisabled
    }
}

extension SignUpView {
    var genderField: some View {
        Picker("Gender", selection: $viewModel.gender) {
            ForEach(Gender.allCases, id: \.self) { value in
                Text(value.rawValue)
                    .tag(value)
            }
        }.pickerStyle(.segmented)
        .foregroundColor(Color(red: 0.773, green: 0.773, blue: 0.781))
    }
}

extension SignUpView {
    var saveButton: some View {
        LoadingButtonView(action: {
            viewModel.signUp()
        },
                          text: "Realize seu cadastro!",
                          showProgress: self.viewModel.uiState == SignUpUIState.loading,
                          disabled: !viewModel.email.isEmail() ||
                          viewModel.password.count < 8 ||
                          viewModel.fullName.count < 3 ||
                          viewModel.document.count != 11 ||
                          viewModel.phone.count < 10 || viewModel.phone.count >= 12 ||
                          viewModel.birthday.count != 10)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            SignUpView(viewModel: SignUpViewModel())
                .preferredColorScheme($0)
        }
    }
}
