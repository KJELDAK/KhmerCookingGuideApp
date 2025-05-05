//
//  SearchBarComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI

struct SearchBarComponent: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image("search")
                .resizable()
                .frame(width: 22, height: 22)
                .padding(.leading, 9)
            ZStack(alignment: .leading) {
                // Placeholder text
                if searchText.isEmpty {
                    Text("search_here")
                        .foregroundColor(Color(hex: "#767388"))
                        .customFontLocalize(size: 16)
                        .padding(.leading, 8)
                }
                // TextField
                TextField("", text: $searchText)
                    .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 35)
            }
            .frame(maxWidth: .infinity, minHeight: 35, maxHeight: 35)
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image("cancel")
                        .resizable()
                        .frame(width: 9, height: 9)
                        .padding(.leading)
                        .zIndex(0)
                }
                .padding(.trailing)
            } else {}
        }
        .background(Color(red: 0.953, green: 0.953, blue: 0.949))
        .cornerRadius(12)
        .zIndex(2)
        .padding()
    }
}
