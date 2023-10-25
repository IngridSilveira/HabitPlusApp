//
//  CustomTextFieldStyle.swift
//  HabitPlus
//
//  Created by userext on 30/08/23.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(Color.gray, lineWidth: 2))
    }
}

//struct CustomTextFieldStyle_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextFieldStyle()
//    }
//}aaa
