//
//  FoodRecipeFilterComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI

struct FoodRecipeFilterComponent: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: String

    @State private var localSelectedType: String

    init(isPresented: Binding<Bool>, selectedType: Binding<String>) {
        _isPresented = isPresented
        _selectedType = selectedType
        _localSelectedType = State(initialValue: selectedType.wrappedValue)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 30) {
                VStack {
                    Text("Filter")
                        .foregroundStyle(Color(hex: "#374957"))
                        .customFontSemiBoldLocalize(size: 20)
                }
                .frame(maxWidth: .infinity, alignment: .center)

                Text("category")
                    .foregroundStyle(Color(hex: "#090920"))
                    .customFontMediumLocalize(size: 16)
                VStack(alignment: .leading, spacing: 25) {
                    ForEach(["All", "Star Rating"].map { $0 as String }, id: \.self) { type in
                        Button(action: {
                            localSelectedType = type
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(localSelectedType == type ? Color(hex: "primary") : Color.black, lineWidth: 2)
                                        .frame(width: 20, height: 20)

                                    if localSelectedType == type {
                                        Circle()
                                            .fill(Color(hex: "primary"))
                                            .frame(width: 10, height: 10)
                                    }
                                }
                                .padding(.horizontal, 2)
                                Text(LocalizedStringKey(type))
                                    .foregroundColor(.black)
                                    .customFontLocalize(size: 18)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            ButtonComponent(action: {
                selectedType = localSelectedType
                isPresented = false

            }, content: "_apply")
                .buttonStyle(.borderedProminent)
        }
        .padding(25)
        .background(Color.white)
        .cornerRadius(15)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FoodRecipeFilterComponent(isPresented: .constant(true), selectedType: .constant("All"))
}
