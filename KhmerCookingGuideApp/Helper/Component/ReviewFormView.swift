//
//  ReviewFormView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/3/25.
//
import SwiftUI

import SwiftUI

struct ReviewFormView: View {
    @StateObject var recipeViewModel = RecipeViewModel()
    @State private var reviewText: String = ""
    @State private var rating: Int = 5 // Default rating
    @Binding var isPresented: Bool  // Use Binding to control visibility
    @State var isShowSuccesAlert: Bool = false
    @State var isShowFaildAlert: Bool = false
    @State var messageFromServer: String = ""
    
//     var action: () -> Void
    var profile: String
    var userName: String
    var foodId : Int?
    @State private var showPopup: Bool = false // For animation

    var body: some View {
        ZStack {
            // Dimmed Background - Tap outside to dismiss
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismissPopup()
                }
                .opacity(showPopup ? 1 : 0) // Fade-in animation
            
            // Review Form with Scale and Opacity Animation
            VStack(spacing: 16) {
                // Profile Section
                HStack {
                    Image(profile) // Replace with actual image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        StarRatingView(rating: $rating) // Interactive stars
                    }
                    
                    Spacer()
                }
                
                // Review Input
                TextEditor(text: $reviewText)
                    .frame(height: 100)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 1))
                
                // Buttons
                HStack {
                    BackButtonComponent(action: {
                        dismissPopup()
                    }, content: "Cancel")
                    ButtonComponent(action: {
                        recipeViewModel.postRateAndFeedback(foodId: foodId!, ratingValue: String(rating), commentText: reviewText) { isSuccess, message in
                            messageFromServer = message
                            if isSuccess{
                                isShowSuccesAlert = true
                            }
                            else{
                                isShowFaildAlert = true
                                print("error")
                            }
                        }
                    }, content: "Post")
                    .disabled(reviewText.isEmpty)
                    .opacity(reviewText.isEmpty ? 0.5 : 1)
                }
                Spacer()
                
            }
            .padding()
            .background(Color.white)
            SuccessAndFailedAlert(status: true, message: messageFromServer, duration: 3, isPresented: $isShowSuccesAlert)
            SuccessAndFailedAlert(status: false, message: messageFromServer, duration: 3, isPresented: $isShowFaildAlert)
    
        }
      
          
        
        
    }
    
    // Dismiss with animation
    private func dismissPopup() {
        withAnimation(.easeOut(duration: 0.3)) {
            showPopup = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// ⭐ Star Rating View
struct StarRatingView: View {
    @Binding var rating: Int
    private let maxRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

// 🌟 Example Usage
struct you: View {
    @State private var isReviewPresented = true

    var body: some View {
        ZStack {
            Button("Write a Review") {
                withAnimation {
                    isReviewPresented = true
                }
            }
            
            if isReviewPresented {
                ReviewFormView(isPresented: $isReviewPresented,profile: "mhob1",userName:"Sok Reaksa")
//                    .transition(.opacity) // Smooth transition
                    .zIndex(1)
            }
        }
    }
}


#Preview{
    you()
}
