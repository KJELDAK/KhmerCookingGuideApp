//
//  AllRateAndFeedbackView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/4/25.
//

import SwiftUI

struct AllRateAndFeedbackView: View {
    @ObservedObject var  recipeViewModel : RecipeViewModel
    var rateAndFeebackPayload: [RatingFeedback]
    var userRateAndFeedbackPayload: UserFoodFeedbackResponse
    @StateObject var profileViewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @State var isNavigateToUpdateRateAndFeedBack: Bool = false
    @State var isDeleteRateAndFeedbackTapped : Bool = false
    @State var messageFromServerWhenDelete = ""
    @State var isShowDeleteRateAndFeedbackFailAlert = false
    @State var isAllRateAndFeedbackEmpty: Bool = false
    var body: some View {
        ZStack{
            NavigationView {
                ScrollView {
                    if rateAndFeebackPayload.isEmpty && userRateAndFeedbackPayload.payload == nil {
                        VStack {
                            Spacer(minLength: 150) // Push down a bit from top
                            Text("no_rating_and_feedback_yet")
                                .customFontKhmer(size: 16)
                                .opacity(0.4)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: 16) {
                            // Show user's own review first
                            if let userPayload = userRateAndFeedbackPayload.payload {
                                ReviewCardView(
                                    userProfile: userPayload.user.profileImage,
                                    userName: userPayload.user.fullName,
                                    reviewText: userPayload.commentText,
                                    rating: userPayload.ratingValue,
                                    isHasThreeDots: true, onEditTapped: {
                                        isNavigateToUpdateRateAndFeedBack = true
                                    }, onDeleteTapped: {
                                        isDeleteRateAndFeedbackTapped = true
                                    }
                                )
                                .padding(.horizontal)
                            }
                            ForEach(rateAndFeebackPayload.filter {
                                $0.user.id != userRateAndFeedbackPayload.payload?.user.id
                            }) { feedback in
                                ReviewCardView(
                                    userProfile: feedback.user.profileImage,
                                    userName: feedback.user.fullName,
                                    reviewText: feedback.commentText,
                                    rating: feedback.ratingValue,
                                    isHasThreeDots: false, onEditTapped: {
                                        
                                    },onDeleteTapped: {}
                                )
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }
                .navigationDestination(isPresented: $isNavigateToUpdateRateAndFeedBack, destination: {
                    updateRateAndFeedbackView(recipeViewModel: recipeViewModel, isPresented: $isNavigateToUpdateRateAndFeedBack , profile: profileViewModel.userInfo?.payload.profileImage ?? "", userName: profileViewModel.userInfo?.payload.fullName ?? "", foodId: recipeViewModel.viewRecipeById?.id).navigationBarBackButtonHidden(true)
                })
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("all_rating_and_review")
                            .customFontSemiBoldLocalize(size: 20)
                    }
                    ToolbarItem( placement: .navigationBarLeading) {
                        Button{
                            dismiss()
                        }label: {
                            Image("backButton")
                        }
                    }
                }
               
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.systemGroupedBackground).ignoresSafeArea())
            }
            if isDeleteRateAndFeedbackTapped{
                DeleteView(
                    status: false,
                    title: "delete_title",
                    message: "delete_message"
                ) {
                    recipeViewModel.deleteRateAndFeedbackById(id: recipeViewModel.userFoodFeedback?.payload?.id ?? 0) { success, message in
                        messageFromServerWhenDelete = message
                        
                        if success {
                            recipeViewModel.getAllRateAndFeedback(foodId: recipeViewModel.viewRecipeById?.id ?? 0) {_, _ in}
                            recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: recipeViewModel.viewRecipeById?.id ?? 0) {_,_ in}
                            recipeViewModel.fetchRecipeById(id: recipeViewModel.viewRecipeById?.id ?? 0) { _, _ in}
                        } else {
                            isShowDeleteRateAndFeedbackFailAlert = true
                        }
                        isDeleteRateAndFeedbackTapped = false
                    }
                } cancelAction: {
                    isDeleteRateAndFeedbackTapped = false
                }
            }
            else if recipeViewModel.isLoadingWhenPerfromAction{
                LoadingComponent()
            }
            SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromServerWhenDelete), duration: 3, isPresented: $isShowDeleteRateAndFeedbackFailAlert)
        }
        .onAppear{
            profileViewModel.getUserInfo { _, _ in
                
            }
        }
    }
}
