//
//  InputComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 28/4/25.
//

import UIKit
struct InputComponent: View {
    @Binding var textInput: String
    @State var placeHolder: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("usernamePlaceholder") // Adjusted for username placeholder image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#374957"))
                
                ZStack(alignment: .leading) {
                    if textInput.isEmpty {
                        Text(placeHolder)
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#757575"))
                    }
                    TextField("", text: $textInput)
                        .customFont(size: 20)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
        }
    }
}
