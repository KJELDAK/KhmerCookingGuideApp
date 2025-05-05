//
//  PopupView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 30/4/25.
//

import SwiftUI

struct PopupView: View {
    @Binding var showPopup: Bool
    var onEditTapped: () -> Void // Callback when "Edit" is tapped
    var onDeleteTapped: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                onEditTapped() // Call the callback when Edit is tapped
            }) {
                HStack {
                    Text("_edit")
                        .customFontLocalize(size: 14)
                    Spacer()
                    Image("pencil")
                }
            }
            .padding(.horizontal, 10)
            .padding(.top)
            Spacer()
            Button(action: {
                showPopup = false
                onDeleteTapped() // Call the callback when delete is tapped
            }) {
                HStack {
                    Text("_delete")
                        .customFontLocalize(size: 14)
                    Spacer()
                    Image("trash")
                }
                .zIndex(10)
            }
            .padding(.bottom)
            .padding(.horizontal, 10)
        }
        .buttonStyle(PlainButtonStyle())
        .frame(width: 109, height: 88, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
//        .shadow(color: Color(hex: "#E6E6E6"), radius: 10, x: 0, y: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#E6E6E6"), lineWidth: 1)
        )
        .zIndex(10)
    }
}
