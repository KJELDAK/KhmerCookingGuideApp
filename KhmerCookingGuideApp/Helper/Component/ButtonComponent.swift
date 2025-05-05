//
//  ButtonComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI

struct ButtonComponent: View {
    var action: () -> Void
    var content: LocalizedStringKey

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(content)
//                .customFontBold(size: 16)
                .customFontSemiBoldLocalize(size: 16)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(CustomButtonStyle())
        .accessibilityLabel(Text(content)) // Optional: for better accessibility
    }
}

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(hex: "FF0000")) // Uncomment if you want the default color
            .opacity(configuration.isPressed ? 0.3 : 1.0)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Press effect
            .animation(.easeInOut(duration: 0.4), value: configuration.isPressed)
    }
}
