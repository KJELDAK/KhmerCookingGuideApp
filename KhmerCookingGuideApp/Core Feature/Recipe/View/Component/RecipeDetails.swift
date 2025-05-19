//
//  RecipeDetails.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 6/1/25.
//
import Kingfisher
import SwiftUI

struct RecipeDetails: View {
    @Binding var isLike: Bool
    @State private var imageHeight: CGFloat = 270 // Default image height
    var id: Int
    private let screenHeight = UIScreen.main.bounds.height // Screen height
    @StateObject var profileViewModel = ProfileViewModel()
    @Environment(\.dismiss) var dismiss
    @StateObject var recipeViewModel = RecipeViewModel()
    @State var image: [Photo] = []
    @State var fileName: String = ""
    @State var isRatingFormPresent: Bool = false
    @State var isSheetPresent: Bool = true
    @State var isNavigateToAllRateAndFeedbackView: Bool = false
    @State var isNavigateToEditRateAndFeedbackView: Bool = false
    @State var isShowPopUp: Bool = false
    @State var isDeleteTapped: Bool = false
    @State var isEditTapped: Bool = false
    @State var isShowDeleteFailAlert: Bool = false
    @State var isShowDeleteRateAndFeedbackFailAlert: Bool = false
    @State var messageFromServerWhenDelete: String = ""
    @State var isDeleteRateAndFeedbackTapped: Bool = false
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        NavigationView {
            ZStack {
                VStack {
                    KFImage(URL(string: imageUrl + fileName))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: imageHeight)
                        .overlay(alignment: .bottom) {
                            Group {
                                HStack {
                                    HStack {
                                        ForEach( /* recipeViewModel.viewRecipeById?.photo ?? [] */ image) { img in
                                            Button(action: {
                                                fileName = img.photo
                                            }) {
                                                KFImage(URL(string: imageUrl + img.photo))
                                                    .resizable()
                                                    .frame(width: 34, height: 34)
                                            }
                                            .frame(width: 34, height: 34)
                                            .background(Color.blue)
                                            .cornerRadius(7)
                                            .padding(0)
                                        }
                                    }.padding(8)
                                }
                                .background(.white.opacity(0.3))
                                .cornerRadius(14)
                                .onAppear {
                                    print(image)
                                }.padding(.bottom, -40)
                            }
                        }
                        .frame(height: imageHeight)
                    Spacer()
                }
                
                .sheet(isPresented: $isSheetPresent) {
                    let sheetHeight = screenHeight - imageHeight - 79
                    NavigationStack {
                        FoodDetails(recipeViewModel: recipeViewModel, isRatingFormPresent: $isRatingFormPresent, isNavigateToAllRateAndFeedbackView: $isNavigateToAllRateAndFeedbackView, isNavigateToEditRateAndFeedbackView: $isNavigateToEditRateAndFeedbackView, onDelete: {
                            isDeleteRateAndFeedbackTapped = true
                        }, foodId: id)
                        
                        .navigationDestination(isPresented: $isRatingFormPresent) {
                            ReviewFormView(recipeViewModel: recipeViewModel, isPresented: $isRatingFormPresent, profile: profileViewModel.userInfo?.payload.profileImage ?? "", userName: profileViewModel.userInfo?.payload.fullName ?? "", foodId: recipeViewModel.viewRecipeById?.id)
                                .navigationBarBackButtonHidden()
                        }
                        .padding(.top)
                        .navigationDestination(isPresented: $isNavigateToAllRateAndFeedbackView) {
                            AllRateAndFeedbackView(recipeViewModel: recipeViewModel, rateAndFeebackPayload: recipeViewModel.viewAllRateAndFeedBack, userRateAndFeedbackPayload: recipeViewModel.userFoodFeedback ?? UserFoodFeedbackResponse(message: "", payload: nil, statusCode: "", timestamp: ""))
                                .navigationBarBackButtonHidden()
                        }
                        .navigationDestination(isPresented: $isNavigateToEditRateAndFeedbackView) {
                            updateRateAndFeedbackView(recipeViewModel: recipeViewModel, isPresented: $isRatingFormPresent, profile: profileViewModel.userInfo?.payload.profileImage ?? "", userName: profileViewModel.userInfo?.payload.fullName ?? "", foodId: recipeViewModel.viewRecipeById?.id)
                                .navigationBarBackButtonHidden()
                        }
                    }
                    .fullScreenCover(
                        isPresented: $isEditTapped,
                        onDismiss: {
                            // 🔄 reload the recipe (including new photos)
                            recipeViewModel.fetchRecipeById(id: id) { success, _ in
                                guard success else { return }
                                image = recipeViewModel.viewRecipeById?.photo ?? []
                                fileName = image.first?.photo ?? ""
                            }
                        }
                    ) {
                        UpdateFoodRecipeView(foodId: id, recipeViewModel: recipeViewModel)
                    }
                    .presentationDetents([.height(sheetHeight), /* .height(sheetHeight + 10)] */ /* .fraction(0.9), */ // almost full screen
                        .large])
                    .presentationBackground(.white)
                    .presentationCornerRadius(20)
                    .interactiveDismissDisabled()
                    .presentationBackgroundInteraction(.enabled)
                    .overlay {
                        if isDeleteTapped {
                            DeleteView(status: false, title: "are_you_sure_to_delete", message: "recipe_will_be_deleted") {
                                recipeViewModel.deleteRecipeById(id: id) { success, message in
                                    messageFromServerWhenDelete = message
                                    if success {
                                        dismiss()
                                    } else {
                                        isShowDeleteFailAlert = true
                                    }
                                }
                                isDeleteTapped = false
                                
                            } cancelAction: {
                                isDeleteTapped = false
                            }
                            .padding(.top, -200)
                        } else if isDeleteRateAndFeedbackTapped {
                            DeleteView(
                                status: false,
                                title: "delete_title",
                                message: "delete_message"
                            ) {
                                recipeViewModel.deleteRateAndFeedbackById(id: recipeViewModel.userFoodFeedback?.payload?.id ?? 0) { success, message in
                                    messageFromServerWhenDelete = message
                                    
                                    if success {
                                        recipeViewModel.getAllRateAndFeedback(foodId: id) { _, _ in }
                                        recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: id) { _, _ in }
                                        recipeViewModel.fetchRecipeById(id: id) { _, _ in }
                                    } else {
                                        isShowDeleteRateAndFeedbackFailAlert = true
                                    }
                                    isDeleteRateAndFeedbackTapped = false
                                }
                            } cancelAction: {
                                isDeleteRateAndFeedbackTapped = false
                            }
                        } else if recipeViewModel.isLoadingWhenPerfromAction {
                            LoadingComponent()
                        } else if isShowDeleteRateAndFeedbackFailAlert {
                            SmallSuccessAndFailedAlert(status: false, message: messageFromServerWhenDelete, duration: 3, isPresented: $isShowDeleteRateAndFeedbackFailAlert).padding(.top, -200)
                        } else if isShowDeleteFailAlert {
                            SmallSuccessAndFailedAlert(status: false, message: messageFromServerWhenDelete, duration: 3, isPresented: $isShowDeleteFailAlert).padding(.top, -200)
                        }
                    }
                }
                if isDeleteTapped {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {}
                        }
                }
                if recipeViewModel.isLoadingWhenPerfromAction {
                    LoadingComponent()
                }
            }
            .overlay(alignment: .topTrailing) {
                if isShowPopUp {
                    PopupView(
                        showPopup: $isShowPopUp,
                        onEditTapped: {
                            isEditTapped = true
                            withAnimation {
                                isShowPopUp = false
                            }
                        },
                        onDeleteTapped: {
                            print("delete")
                            isDeleteTapped = true
                            withAnimation {
                                isShowPopUp = false
                            }
                        }
                    )
                    .padding(16)
                    .padding(.top, 90)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isShowPopUp)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                        print("back")
                    } label: {
                        Image("backButton2")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if HeaderToken.shared.role == "ROLE_ADMIN" {
                        HStack(spacing: 0) {
                            HeartButton2(
                                isLiked: $isLike,
                                foodId: id,
                                itemType: "FOOD_RECIPE"
                            )
                            Button(action: {
                                isShowPopUp.toggle()
                            }) {
                                Image("three-dot")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .accessibilityLabel("More options")
                            }
                        }
                    } else {
                        HeartButton2(
                            isLiked: $isLike,
                            foodId: id,
                            itemType: "FOOD_RECIPE"
                        )
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            recipeViewModel.fetchRecipeById(id: id) { _, message in
                print(message)
                DispatchQueue.main.async {
                    image = recipeViewModel.viewRecipeById?.photo ?? []
                    print("this is image hahahh", image)
                    fileName = recipeViewModel.viewRecipeById?.photo.first?.photo ?? ""
                }
            }
            recipeViewModel.getAllRateAndFeedback(foodId: id) { _, message in
                print(message)
            }
            recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: id) { _, message in
                print(message)
            }
            profileViewModel.getUserInfo { _, _ in
            }
        }
    }
}

struct FoodDetails: View {
    @State var isClicked: Bool = false
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var clickedIngredients: Set<Int> = []
    @Binding var isRatingFormPresent: Bool
    @Binding var isNavigateToAllRateAndFeedbackView: Bool
    @State var isShowPopover: Bool = false
    @Binding var isNavigateToEditRateAndFeedbackView: Bool
    var onDelete: () -> Void
    var foodId: Int
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/\(recipeViewModel.viewRecipeById?.user.profileImage ?? "")"
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Text(recipeViewModel.viewRecipeById?.name ?? "")
                        .customFontKhmerSemiBold(size: 17)
                        .foregroundColor(Color(hex: "primary"))
                    HStack {
                        HStack {
                            Group {
                                Text(LocalizedStringKey(recipeViewModel.viewRecipeById?.cuisineName ?? ""))
                                Image("dot")
                                Text(String(recipeViewModel.viewRecipeById?.durationInMinutes ?? 0))
                                Text("_minutes")
                            }
                            .customFontKhmerMedium(size: 16)
                            .foregroundColor(Color(hex: "9FA5C0"))
                            Spacer()
                            
                            Text(Settings.shared.formattedDate(from: recipeViewModel.viewRecipeById?.createdAt ?? ""))
                                .customFontKhmer(size: 10)
                                .padding(.top, 2)
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    HStack {
                        if recipeViewModel.viewRecipeById?.user.profileImage == "default.jpg" {
                            Image("defaultPFMale")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(16)
                            
                        } else {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(16)
                        }
                        Text(recipeViewModel.viewRecipeById?.user.fullName ?? "")
                            .customFontRobotoBold(size: 17)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("_description")
                            .customFontSemiBoldLocalize(size: 16)
                        if LanguageDetector.shared.isKhmerText(recipeViewModel.viewRecipeById?.description ?? "") {
                            Text(recipeViewModel.viewRecipeById?.description ?? "")
                                .customFontKhmer(size: 16)
                                .opacity(0.6)
                                .lineSpacing(6)
                            
                        } else {
                            Text(recipeViewModel.viewRecipeById?.description ?? "")
                                .customFontRobotoRegular(size: 16)
                                .opacity(0.6)
                                .lineSpacing(6)
                        }
                    }
                }.padding(.horizontal)
                Divider()
                VStack(alignment: .leading) {
                    Text("ingredients")
                        .customFontSemiBoldLocalize(size: 16)
                    ForEach(recipeViewModel.viewRecipeById?.ingredients ?? []) { ingredient in
                        HStack {
                            Button {
                                // Toggle the state for the specific ingredient
                                if clickedIngredients.contains(ingredient.id) {
                                    clickedIngredients.remove(ingredient.id)
                                } else {
                                    clickedIngredients.insert(ingredient.id)
                                }
                            } label: {
                                Image(clickedIngredients.contains(ingredient.id) ? "doneCircle" : "checkCircle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }.opacity(0.6)
                            Group {
                                Text(ingredient.name)
                                Text(ingredient.quantity)
                            }
                            .opacity(0.6)
                            .customFontKhmer(size: 17)
                        }
                    }
                }
                .padding(.horizontal)
                Divider()
                ForEach(Array(zip(1..., recipeViewModel.viewRecipeById?.cookingSteps ?? [])), id: \.1.description) { (index, cookingStep) in
                    VStack(alignment: .leading) {
                        Text("step")
                            .customFontSemiBoldLocalize(size: 16)
                        HStack(alignment: .top) {
                            Circle()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(hex: "2E3E5C"))
                                .overlay {
                                    Text(String(index))
                                        .foregroundColor(.white)
                                        .customFontRobotoBold(size: 12)
                                }
                            Text(cookingStep.description)
                                .customFontKhmer(size: 17)
                                .lineSpacing(6)
                                .opacity(0.6)
                        }
                    }
                    .padding(.horizontal)
                    Divider()
                }
                RatingsAndReviewView(averageRating: recipeViewModel.viewRecipeById?.averageRating ?? 0, reviewCount: recipeViewModel.viewRecipeById?.totalRaters ?? 0, ratePercentage: recipeViewModel.viewRecipeById?.ratingPercentages ?? RatingPercentages(one: 0, two: 0, three: 0, four: 0, five: 0), onTappAction: {
                    isNavigateToAllRateAndFeedbackView = true
                })
                Spacer()
                let isMyFeedbackValid = (recipeViewModel.userFoodFeedback?.payload?.commentText.isEmpty == false)
                && (recipeViewModel.userFoodFeedback?.payload?.user.fullName.isEmpty == false)
                
                var userProfile = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload?.user.profileImage ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.user.profileImage ?? "")
                
                var userName = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload?.user.fullName ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.user.fullName ?? "")
                
                var reviewText = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload?.commentText ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.commentText ?? "")
                
                var totalRating = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload?.ratingValue ?? 0)
                : (recipeViewModel.viewAllRateAndFeedBack.first?.ratingValue ?? 0)
                
                ReviewSectionView(
                    writingReviewButton: {
                        isRatingFormPresent = true
                    },
                    totalStarRating: totalRating,
                    userProfile: userProfile,
                    userName: userName,
                    reviewText: reviewText,
                    isHasThreeDots: isMyFeedbackValid
                ) {
                    isNavigateToEditRateAndFeedbackView = true
                } onDeleteTapeed: {
                    onDelete()
                    recipeViewModel.getAllRateAndFeedback(foodId: foodId) { _, _ in
                    }
                    recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: foodId) { _, _ in
                    }
                    recipeViewModel.fetchRecipeById(id: foodId) { _, _ in }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            recipeViewModel.getAllRateAndFeedback(foodId: foodId) { _, message in
                print(message)
            }
            recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: foodId) { _, message in
                print(message)
            }
        }
    }
}
