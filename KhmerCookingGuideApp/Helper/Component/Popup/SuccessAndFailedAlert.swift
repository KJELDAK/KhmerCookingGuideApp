//
//  SuccessAndFailedAlert.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 11/12/24.
//

import SwiftUI



struct SuccessAndFailedAlert: View {
    var status: Bool
     var message: String
    let duration : Double
    @Binding var isPresented: Bool
    @State var scale:CGFloat = 0.0
    @State var opacity:Double = 1
    
    var body: some View {
        if isPresented {
            ZStack{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            scale = 1
                            opacity = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration){
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                scale = 0
                                opacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                isPresented = false
                            }
                        }
                    }
                
                VStack(spacing: 20) {
                    // Status Icon
                    Image(systemName: status == true ? "checkmark" : "multiply")
                        .resizable()
                        .frame(width: status == true ? 24 : 16, height: status == true ? 17 : 16)
                        .frame(width: 48, height: 48)
                        .foregroundColor(status == true ? Color(hex: "#00BA00") : Color(hex: "#EC221F"))
                        .background(Circle().fill(status == true ? Color(hex: "#00BA00").opacity(0.15) : Color(hex: "#EC221F").opacity(0.15)))
                        .scaleEffect(scale)
                    // Success or Failed message text
                    Text(message)
                        .customFont(size: 16)
                        .foregroundColor(Color(hex: "#9E9E9E"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 250)
                .background(Color(hex: "#FCFDFF"))
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
                .padding(.horizontal,50)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        scale = 1
                        opacity = 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration){
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            scale = 0
                            opacity = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}



struct SmallSuccessAndFailedAlert: View {
    var status: Bool
    var message: String
    let duration : Double
    @Binding var isPresented: Bool
    @State var scale: CGFloat = 0.0
    @State var opacity: Double = 1
    
    var body: some View {
        if isPresented {
            ZStack(alignment: .top) { // Set alignment to top here
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            scale = 1
                            opacity = 1
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration){
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                scale = 0
                                opacity = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                                isPresented = false
                            }
                        }
                    }
                
                VStack(spacing: 20) {
                    // Status Icon
                    Image(systemName: status == true ? "checkmark" : "multiply")
                        .resizable()
                        .frame(width: status == true ? 24 : 16, height: status == true ? 17 : 16)
                        .frame(width: 48, height: 48)
                        .foregroundColor(status == true ? Color(hex: "#00BA00") : Color(hex: "#EC221F"))
                        .background(Circle().fill(status == true ? Color(hex: "#00BA00").opacity(0.15) : Color(hex: "#EC221F").opacity(0.15)))
                        .scaleEffect(scale)
                    // Success or Failed message text
                    Text(message)
                        .customFont(size: 16)
                        .foregroundColor(Color(hex: "#9E9E9E"))
                        .multilineTextAlignment(.center)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: 150)
                .background(Color(hex: "#FCFDFF"))
                .cornerRadius(35)
                .overlay(
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
                .padding(.horizontal, 120)
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure it takes full screen space
            .padding(.top, 1) // Adjust top padding as needed to position the alert
        }
    }
}
