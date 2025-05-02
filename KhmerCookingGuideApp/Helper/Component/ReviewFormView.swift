//
//  ReviewFormView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/3/25.
//
import SwiftUI

import Kingfisher

struct ReviewFormView: View {
    @ObservedObject var recipeViewModel : RecipeViewModel
    @State private var reviewText: String = ""
    @State private var rating: Int = 5 // Default rating
    @Binding var isPresented: Bool  // Use Binding to control visibility
    @State var isShowSuccesAlert: Bool = false
    @State var isShowFaildAlert: Bool = false
    @State var messageFromServer: String = ""
    @Environment(\.dismiss) var dismiss
    //     var action: () -> Void
    var profile: String
    var userName: String
    var foodId : Int?
    @State private var showPopup: Bool = false // For animation
    
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView{
            ZStack {
                // Dimmed Background - Tap outside to dismiss
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissPopup()
                    }
                    .opacity(showPopup ? 1 : 0) 
                
                // Review Form with Scale and Opacity Animation
                VStack(spacing: 16) {
                    // Profile Section
                    HStack {
                        if profile == "" {
                            Image(profile)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        else{
                            KFImage(URL(string: imageUrl + profile))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                               
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
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
                                    recipeViewModel.fetchRecipeById(id: foodId ?? 0) { _, _ in
                                        
                                    }
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
                    .onDisappear{
                        dismiss()
                    }
                SuccessAndFailedAlert(status: false, message: messageFromServer, duration: 3, isPresented: $isShowFaildAlert)
                    .onDisappear{
                        dismiss()
                    }
                
            }
            .toolbar {
                ToolbarItem( placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image("backButton")
                    }
                }
                ToolbarItem( placement: .principal) {
                    Text("write_a_review")
                        .customFontSemiBoldLocalize(size: 20)
                }
                
                
            } .navigationBarTitleDisplayMode(.inline)
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

struct updateRateAndFeedbackView: View {
    @ObservedObject var recipeViewModel :RecipeViewModel
    @State private var reviewText: String = ""
    @State private var rating: Int = 5 // Default rating
    @Binding var isPresented: Bool  // Use Binding to control visibility
    @State var isShowSuccesAlert: Bool = false
    @State var isShowFaildAlert: Bool = false
    @State var messageFromServer: String = ""
    @Environment(\.dismiss) var dismiss
    //     var action: () -> Void
    var profile: String
    var userName: String
    var foodId : Int?
    @State var feedbackId : Int = 0
    @State private var showPopup: Bool = false // For animation
    
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView{
            ZStack {
                // Dimmed Background - Tap outside to dismiss
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissPopup()
                    }
                    .opacity(showPopup ? 1 : 0)
                
                // Review Form with Scale and Opacity Animation
                VStack(spacing: 16) {
                    // Profile Section
                    HStack {
                        if profile == "" {
                            Image(profile)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        }
                        else{
                            KFImage(URL(string: imageUrl + profile))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                               
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
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
                            recipeViewModel.updateRateAndFeedback(feedBackId: feedbackId,foodId: foodId!, ratingValue: String(rating), commentText: reviewText) { isSuccess, message in
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
                    .onDisappear{
                        recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: foodId ?? 0) { _, _ in
                            
                        }
                        recipeViewModel.getAllRateAndFeedback(foodId: foodId ?? 0) { _, _ in
                            
                        }
                        recipeViewModel.fetchRecipeById(id: foodId ?? 0) { _, _ in
                            
                        }
                        dismiss()
                    }
                SuccessAndFailedAlert(status: false, message: messageFromServer, duration: 3, isPresented: $isShowFaildAlert)
                    .onDisappear{
                        dismiss()
                    }
                
            }
            .onAppear{
                recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: foodId ?? 0) { success, message in
                    if success{
                        reviewText = recipeViewModel.userFoodFeedback?.payload?.commentText ?? ""
                        rating = recipeViewModel.userFoodFeedback?.payload?.ratingValue ?? 0
                        feedbackId = recipeViewModel.userFoodFeedback?.payload?.id ?? 0
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem( placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    }label: {
                        Image("backButton")
                    }
                }
                ToolbarItem( placement: .principal) {
                    Text("write_a_review")
                        .customFontSemiBoldLocalize(size: 20)
                }
                
                
            } .navigationBarTitleDisplayMode(.inline)
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


