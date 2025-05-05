//
//  DeleteView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 30/4/25.
//

import SwiftUI

struct DeleteView: View {
    @State var status: Bool
    var title: String
    var message: String
    @State var scale: CGFloat = 0.0
    @State var opacity: Double = 1
    var confirmAction: () -> Void
    var cancelAction: () -> Void

    private func closePopup() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
            scale = 0
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cancelAction()
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        scale = 1
                        opacity = 1
                    }
                }
            VStack(spacing: 15) {
                Image(systemName: status == true ? "checkmark" : "trash")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .frame(width: 60, height: 60)
                    .foregroundColor(status == true ? Color(hex: "#3F61E9") : Color(hex: "#EC221F"))
                    .background(Circle().fill(status == true ? Color(hex: "#D2DAFF") : Color(hex: "#EC221F").opacity(0.15)))
                Text(LocalizedStringKey(title))
                    .customFontMediumLocalize(size: 16)
                    .multilineTextAlignment(.center)
                Text(LocalizedStringKey(message))
                    .customFontLocalize(size: 13)
                    .foregroundStyle(Color(hex: "#9E9E9E"))
                    .multilineTextAlignment(.center)
                HStack(spacing: 15) {
                    Button(action: {
                        closePopup()
                    }) {
                        Spacer()
                        Text("_cancel")
                            .customFontMediumLocalize(size: 13)
                            .foregroundColor(Color(hex: "#757575"))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .background(Color(hex: "#E5E7EB").opacity(0.5))
                    .cornerRadius(10)

                    Button(action: {
                        confirmAction()
                    }) {
                        Spacer()
                        Text("_confirm")
                            .customFontMediumLocalize(size: 13)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .background(status == true ? Color(hex: "#3F61E9") : Color(hex: "#EC221F"))
                    .cornerRadius(10)
                }
                .padding(.horizontal, 25)
                .offset(y: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: 260)
            .background(Color(hex: "#FCFDFF"))
            .cornerRadius(35)
            .overlay(
                RoundedRectangle(cornerRadius: 35)
                    .stroke(Color(hex: "#0C0C0D").opacity(0.1), lineWidth: 2)
            )
            .padding(.horizontal, 40)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    scale = 1
                    opacity = 1
                }
            }
        }
    }
}
