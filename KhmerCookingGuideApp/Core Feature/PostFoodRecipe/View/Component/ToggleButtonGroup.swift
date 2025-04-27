//
//  ToggleButtonGroup.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 17/1/25.
//
import SwiftUI

struct ToggleButtonGroup: View {
    let title: String               // Title for the section
    let items: [String]             // Array of items to display as buttons
    @Binding var selection: String // Binding for the selected items (multi-selection)
    let isSingleSelection: Bool     // Flag to toggle between single and multi-selection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(LocalizedStringKey(title))
                .customFontMediumLocalize(size: 16)
            

            ScrollView(.horizontal){
                HStack {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
//                            if isSingleSelection {
                                // Single selection behavior
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                                           selection = item
                                                       }
                                
//                            } else {
//                                // Multi-selection behavior
//                                if selection.contains(item) {
//                                    selection.remove(item)
//                                } else {
//                                    selection.insert(item)
//                                }
//                            }
                        }) {
                            Text(item)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selection.contains(item) ? Color(hex: "primary") : Color.clear)
                                .foregroundColor(selection.contains(item) ? .white : .gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selection.contains(item) ? Color.yellow : Color.gray, lineWidth: 1)
                                )
                                .cornerRadius(8)
                        }
                    }
                }

            }
            .scrollIndicators(.hidden)
        }
    }
}
