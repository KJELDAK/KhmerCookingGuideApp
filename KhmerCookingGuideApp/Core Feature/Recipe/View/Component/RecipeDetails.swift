//
//  RecipeDetails.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 6/1/25.
//

import SwiftUI
import SwiftUI
import Kingfisher

struct RecipeDetails: View {
    @Binding var isLike: Bool
    @State private var imageHeight: CGFloat = 270 // Default image height
    var id : Int
    private let screenHeight = UIScreen.main.bounds.height // Screen height
    @Environment(\.dismiss) var dismiss
    @StateObject var recipeViewModel = RecipeViewModel()
    @State var image : [Photo] = []
    @State var fileName : String = ""
    @State var isRatingFormPresent: Bool = false
    @State var isSheetPresent: Bool = true
    @State var isNavigateToAllRateAndFeedbackView : Bool = false
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
                            //                                AllImageInRecipe(image:image)
                            Group{
                                HStack {
                                    HStack{
                                        ForEach(/*recipeViewModel.viewRecipeById?.photo ?? []*/ image) { img in
                                            Button(action: {
                                                // Print when button is clicked and show photo ID
                                                print("Button clicked: \(img.id), \(img.photo)")
                                                fileName = img.photo
                                            }) {
                                                KFImage(URL(string: imageUrl + img.photo))
                                                    .resizable()
                                                    .frame(width: 34, height: 34) // Adjust the size for visibility
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
                                } .padding(.bottom, -40)
                            }
                        }
                        .frame(height: imageHeight)
                    Spacer()
                }
                .sheet(isPresented: $isSheetPresent) {
                    let sheetHeight = screenHeight - imageHeight - 79 // Calculate dynamic sheet height
                    NavigationStack {
                        FoodDetails(recipeViewModel: recipeViewModel, isRatingFormPresent: $isRatingFormPresent,isNavigateToAllRateAndFeedbackView: $isNavigateToAllRateAndFeedbackView, foodId: id)
                            .navigationDestination(isPresented: $isRatingFormPresent) {
                                ReviewFormView(isPresented: $isRatingFormPresent, profile: "mhob1", userName: "reaksa",foodId: recipeViewModel.viewRecipeById?.id)
                                    .navigationBarBackButtonHidden()
                            }
                            .padding(.top)
                            .navigationDestination(isPresented: $isNavigateToAllRateAndFeedbackView) {
                                AllRateAndFeedbackView(rateAndFeebackPayload: recipeViewModel.viewAllRateAndFeedBack)
                                    .navigationBarBackButtonHidden()
                            }
                        
                    }
                    .presentationDetents([.height(sheetHeight), /*.height(sheetHeight + 10)]*/ /*.fraction(0.9),*/             // almost full screen
                        .large])
                    .presentationBackground(.white)
                    .presentationCornerRadius(20)
                    .interactiveDismissDisabled()
                    .presentationBackgroundInteraction(.enabled)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        dismiss()
                        print("back")
                    }label: {
                        Image("backButton2")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HeartButton2(
                        isLiked: $isLike, // ideally you’d track this at view level
                        foodId: id,
                        itemType: "FOOD_RECIPE"
                        
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear{
            recipeViewModel.fetchRecipeById(id: id) { success, message in
                print(message)
                DispatchQueue.main.async {
                    image = recipeViewModel.viewRecipeById?.photo ?? []
                    print("this is image", image)
                    fileName = recipeViewModel.viewRecipeById?.photo.first?.photo ?? ""
                }
            }
            recipeViewModel.getAllRateAndFeedback(foodId: id) { success, message in
                print(message)
            }
            recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: id) { success, message in
                print(message)
            }
            
        }
    }
}
struct FoodDetails : View{
    @State var isClicked: Bool = false
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var clickedIngredients: Set<Int> = []
    @Binding var isRatingFormPresent: Bool
    @Binding var isNavigateToAllRateAndFeedbackView: Bool
    var foodId: Int
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/\(recipeViewModel.viewRecipeById?.user.profileImage ?? "")"
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    
                    Text(recipeViewModel.viewRecipeById?.name ?? "")
                        .customFontKhmerSemiBold(size: 17)
                        .foregroundColor(Color(hex: "primary"))
                    HStack{
                        HStack{
                            Group{
                                Text(recipeViewModel.viewRecipeById?.cuisineName ?? "")
                                Image("dot")
                                Text(String(recipeViewModel.viewRecipeById?.durationInMinutes ?? 0))
                                Text("minutes")
                            }
                            .customFontKhmerMedium(size: 16)
                            .foregroundColor(Color(hex: "9FA5C0"))
                            Spacer()
                            
                            Text(Settings.shared.formattedDate(from: recipeViewModel.viewRecipeById?.createdAt ?? "") )
                            //                                    .customFontRobotoRegular(size: 10)
                                .customFontKhmer(size: 10)
                                .padding(.top, 2)
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    HStack{
                        if recipeViewModel.viewRecipeById?.user.profileImage == "default.jpg"{
                            Image("defaultPFMale")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(16)
                            
                        }else{
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .frame(width: 32, height: 32)
                                .cornerRadius(16)
                        }
                        Text(recipeViewModel.viewRecipeById?.user.fullName ?? "")
                            .customFontRobotoBold(size: 17)
                    }
                    VStack(alignment: .leading, spacing: 10){
                        Text("decription")
                            .customFontSemiBoldLocalize(size: 16)
                        if LanguageDetector.shared.isKhmerText(recipeViewModel.viewRecipeById?.description ?? "") {
                            Text(recipeViewModel.viewRecipeById?.description ?? "")
                                .customFontKhmer(size: 16)
                                .opacity(0.6)
                                .lineSpacing(6)
                            
                        }else{
                            Text(recipeViewModel.viewRecipeById?.description ?? "")
                                .customFontRobotoRegular(size: 16)
                                .opacity(0.6)
                                .lineSpacing(6)
                            
                        }
                        
                    }
                }.padding(.horizontal)
                Divider()
                VStack(alignment: .leading){
                    Text("ingredients")
                    //                        .customFontRobotoBold(size: 17)
                        .customFontSemiBoldLocalize(size: 16)
                    ForEach(recipeViewModel.viewRecipeById?.ingredients ?? []){ ingredient in
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
                            //                            Text(ingredient.quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(format : "%.0f", ingredient.quantity) : String(format : "%.1f", ingredient.quantity))
                            
                            Group{
                                Text(ingredient.quantity)
                                Text(ingredient.name)
                            }
                            .opacity(0.6)
                            .customFontKhmer(size: 17)
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
                Divider()
                ForEach(recipeViewModel.viewRecipeById?.cookingSteps ?? []){ cookingStep in
                    VStack(alignment: .leading){
                        Text("step")
                            .customFontSemiBoldLocalize(size: 16)
                        HStack(alignment:.top){
                            Circle()
                                .frame(width: 24, height: 24) // Adjust the size of the circle
                                .foregroundColor(Color(hex: "2E3E5C"))
                                .overlay {
                                    Text(String(cookingStep.id))
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
                RatingsAndReviewView(averageRating: recipeViewModel.viewRecipeById?.averageRating ?? 0, reviewCount: recipeViewModel.viewRecipeById?.totalRaters ?? 0, onTappAction: {
                    isNavigateToAllRateAndFeedbackView = true
                })
                Spacer()
                let isMyFeedbackValid = (recipeViewModel.userFoodFeedback?.payload.commentText.isEmpty == false)
                && (recipeViewModel.userFoodFeedback?.payload.user.fullName.isEmpty == false)
                
                let userProfile = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload.user.profileImage ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.user.profileImage ?? "")
                
                let userName = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload.user.fullName ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.user.fullName ?? "")
                
                let reviewText = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload.commentText ?? "")
                : (recipeViewModel.viewAllRateAndFeedBack.first?.commentText ?? "")
                
                let totalRating = isMyFeedbackValid
                ? (recipeViewModel.userFoodFeedback?.payload.ratingValue ?? 0)
                : (recipeViewModel.viewAllRateAndFeedBack.first?.ratingValue ?? 0)
                
                ReviewSectionView(
                    writingReviewButton: {
                        isRatingFormPresent = true
                    },
                    totalStarRating: totalRating,
                    userProfile: userProfile,
                    userName: userName,
                    reviewText: reviewText
                )
                
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .onAppear{
            recipeViewModel.getAllRateAndFeedback(foodId: foodId) { success, message in
                print(message)
            }
            recipeViewModel.getFeedBackByFoodItemForCurrentUser(foodId: foodId) { success, message in
                print(message)
            }

        }
    }
}
