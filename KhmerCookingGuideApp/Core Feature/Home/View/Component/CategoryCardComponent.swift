//
//  CategoryView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 24/12/24.
//

import SwiftUI
struct CategoryCardComponent : View {
    var title: String?
    var image: String?
    var body: some View {
        VStack{
            VStack{
            
                ZStack{
                    VStack{
                        Text(LocalizedStringKey(title ?? "Soup") )
//                            .customFontRobotoMedium(size: 14)
                            .customFontLocalize(size: 14)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 70)
                    Image(image ?? "mhob7")
                        .resizable()
                        .frame(width: 54, height: 54)
                        .offset(x:90,y: 20)
                }
                .padding(.leading)
            }
           
            .frame(width: 146, height: 73,alignment: .leading)
           
            .background(Color(hex: title  == "Breakfast" ? "#f2f2f2" : title == "Lunch" ? "#D0E8D4" :title == "Dinner " ? "#BFDCCB" : title == "Steamed Dishes" ? "#F6F2ED" : title == "Drinks and Beverages" ? "#C2D5E6":"#F4EDE6" ))
            .cornerRadius(15)
          
            .clipped()
        }
    }
}
#Preview {
    CategoryCardComponent()
}
