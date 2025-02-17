//
//  GenderPickerComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 19/12/24.
//
import SwiftUI

struct GenderPickerComponent: View {
    @Binding var placeHolder: String
    @Binding var image: String
    @State private var isPickerVisible = false
    @State private var genders                    = ""
    @State var isTap = false
    @Binding var requestGender: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#374957"))
                    .opacity(0.4)
                
                ZStack(alignment: .leading) {
                    if genders.isEmpty {
                        Text(placeHolder)
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#757575"))
                    } else {
                        Text(genders)
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#090920"))
                    }
                }
                Spacer()
                Image("angle-right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16,height: 16)
                    .overlay(
                        Picker("", selection: $genders) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                            .pickerStyle(MenuPickerStyle())
                            .labelsHidden()
                            .colorMultiply(.clear)
                            .clipped()
                           
                    )
                    .onChange(of: genders) {
                        requestGender = genders
                        
                    }
                    
            }
            .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
            )
            }
    }
}

//#Preview {
//    GenderPickerComponent(
//        placeHolder: .constant("Select Gender"),
//        selectedGender: .constant(""),
//        image: .constant("gender")
//    )
//}
