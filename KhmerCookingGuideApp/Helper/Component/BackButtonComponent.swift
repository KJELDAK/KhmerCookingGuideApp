//
//  BackButtonComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 19/1/25.
//

import SwiftUI

//
//  RejectButtonComponent.swift
//  WeHR
//
//  Created by Sok Reaksa on 11/10/24.
//

import SwiftUI

struct BackButtonComponent: View {
    @State var action: () -> Void
    var content: LocalizedStringKey
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Text(content)
                .customFontSemiBoldLocalize(size: 16)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "EC221F"))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
        })
        .buttonStyle(CustomRejectButtonStyle())
    }
}

#Preview {
    BackButtonComponent(action: {}, content: "Reject")
}

struct CustomRejectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.7 : 1.0) // Press effect
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "EC221F"), lineWidth: 1)
                    .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
            )
    }
}
