//
//  SearchNotFoundComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 8/3/25.
//

import SwiftUI

struct SearchNotFoundComponent: View {
    var content: String
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
                Image("404")
                    .resizable()
                    .frame(width: 120,height: 120)
                    .aspectRatio(contentMode: .fit)
                   
                VStack{
                    Text(LocalizedStringKey(content))
                        .customFontLocalize(size: 20)
                    Text("please_try_again")
                        .customFontLocalize(size: 16)
                        .foregroundColor(Color(hex: "9E9E9E"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                }
                   
            }
    }
}

