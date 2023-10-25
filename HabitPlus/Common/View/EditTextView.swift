//
//  EditTextView.swift
//  HabitPlus
//
//  Created by userext on 30/08/23.
//

import SwiftUI

struct EditTextView: View {
    
    @Binding var text: String
    
    var placeholder: String = ""
    var keyboard: UIKeyboardType = .default
    var error: String? = nil
    var failure: Bool? = nil
    var isSecure: Bool = false
    
    var body: some View {
        VStack {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(Color("TextColor"))
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color("TextColor"))
                    .keyboardType(keyboard)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            if let error = error, failure == true, !text.isEmpty {
                Text(error).foregroundColor(.red)
            }
        }.padding(.vertical, 8)
    }
}

struct EditTextView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { value in
            VStack {
                EditTextView(text: .constant(""),
                             placeholder: "E-mail",
                             error: "Campo inválido",
                             failure: "a@a.com".count < 3)
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .preferredColorScheme(value)
        }
    }
}
