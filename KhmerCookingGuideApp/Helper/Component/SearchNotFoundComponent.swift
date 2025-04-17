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
                Image("notfound")
                    .resizable()
                    .frame(width: 200,height: 200)
                    .aspectRatio(contentMode: .fit)
                   
                VStack{
                    Text(content)
                        .customFontRobotoRegular(size: 20)
                    Text("Please try again")
                        .customFontRobotoRegular(size: 16)
                        .foregroundColor(Color(hex: "9E9E9E"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                }.padding(.top,-60)
                   
            }
    }
}

