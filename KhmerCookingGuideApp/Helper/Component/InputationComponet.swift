//
//  InputComponet.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI

struct InputationComponet: View {
    @Binding var placeHolder: String
    @Binding var textInput: String
    @Binding var image: String
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(image)
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
                        .customFont(size: 16)
                        .multilineTextAlignment(.leading)
                        .onChange(of: textInput){
//                            newValue in
                           
                        }
                }
            }
            .frame( maxWidth: .infinity,minHeight: 36, maxHeight: 36)
            .padding(.horizontal,15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke( Color(hex: "#E5E7EB") , lineWidth: 1)
            )

        }
    }
}

