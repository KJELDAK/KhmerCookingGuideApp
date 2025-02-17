//
//  LoadingComponent.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//

import SwiftUI

import SwiftUI

struct LoadingComponent: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color(red: 217 / 255, green: 217 / 255, blue: 217 / 255, opacity: 0.69) )
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "primary")))
                .scaleEffect(2) // Increase scale for larger effect
                .frame(width: 100, height: 100)
        }
       
    }
}

#Preview {
    LoadingComponent()
}

#Preview {
    LoadingComponent()
}
