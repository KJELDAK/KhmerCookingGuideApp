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
    @State var isLike: Bool = false
    @State private var imageHeight: CGFloat = 270 // Default image height
    var id : Int
    private let screenHeight = UIScreen.main.bounds.height // Screen height
    @Environment(\.dismiss) var dismiss
    @StateObject var recipeViewModel = RecipeViewModel()
    @State var image : [Photo] = []
    @State var fileName : String = ""
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
                                    //            let photos = [
                                    //                Photo(id: 999, photo: "mhob1"),
                                    //                Photo(id: 1000, photo: "mhob2"),
                                    //                Photo(id: 1001, photo: "mhob3"),
                                    //                Photo(id: 1001, photo: "mhob3")
                                    //            ]
                                    //            image.append(contentsOf: photos)
                                    print(image)
                                } .padding(.bottom, -40)
                                
                            }
                            
                            
                        }
                        .frame(height: imageHeight)
                    Spacer()
                }
                .sheet(isPresented: .constant(true)) {
                    let sheetHeight = screenHeight - imageHeight - 79 // Calculate dynamic sheet height
                    FoodDetails(recipeViewModel: recipeViewModel)
                        .presentationDetents([.height(sheetHeight), .height(sheetHeight + 10)])
                        .presentationBackground(.white)
                        .presentationCornerRadius(20)
                        .interactiveDismissDisabled()
                        .presentationBackgroundInteraction(.enabled)
                        .padding(.top)
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
                    Image("backButton2")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HeartButton(isLiked: $isLike)
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
        }
    }
}
//
struct FoodDetails : View{
    @State var isClicked: Bool = false
    @ObservedObject var recipeViewModel: RecipeViewModel
    @State private var clickedIngredients: Set<Int> = [] // Track clicked ingredients by their ID
    
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/\(recipeViewModel.viewRecipeById?.user.profileImage ?? "")"
        ScrollView{
            VStack(alignment: .leading, spacing: 10){
                VStack(alignment: .leading){
                    Text(recipeViewModel.viewRecipeById?.name ?? "")
                        .customFontRobotoBold(size: 17)
                    Text(recipeViewModel.viewRecipeById?.createdAt ?? "")
                        .customFontRobotoRegular(size: 10)
                        .foregroundColor(.black.opacity(0.4))
                    HStack{
                        Group{
                            Text(recipeViewModel.viewRecipeById?.categoryName ?? "")
                            Image("dot")
                            Text(String(recipeViewModel.viewRecipeById?.durationInMinutes ?? 0))
                            Text("minutes")
                        }
                        .customFontRobotoMedium(size: 17)
                        .foregroundColor(Color(hex: "9FA5C0"))
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
                        Text("Decription")
                            .customFontRobotoBold(size: 16)
                        Text(recipeViewModel.viewRecipeById?.description ?? "")
                            .customFont(size: 16)
                            .opacity(0.6)
                            .lineSpacing(10)
                    }
                }.padding(.horizontal)
                Divider()
                VStack(alignment: .leading){
                    Text("Ingredients")
                        .customFontRobotoBold(size: 17)
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
                            }
                            Text(ingredient.quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(format : "%.0f", ingredient.quantity) : String(format : "%.1f", ingredient.quantity))
                                .customFontMedium(size: 15)
                            Text(ingredient.name)
                                .customFontMedium(size: 15)
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
                Divider()
                ForEach(recipeViewModel.viewRecipeById?.cookingSteps ?? []){ cookingStep in
                    VStack(alignment: .leading){
                        Text("Steps")
                            .customFontRobotoBold(size: 17)
                            
                        HStack(alignment:.top){
                            Circle()
                                .frame(width: 24, height: 24) // Adjust the size of the circle
                                .foregroundColor(Color(hex: "2E3E5C"))
                                .overlay {
                                    Text(String(cookingStep.id))
                                        .foregroundColor(.white)
                                        .customFontRobotoBold(size: 12)
                                }
//                                .padding(.top,-35)
                            Text(cookingStep.description)
                            
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                }
                RatingsAndReviewView()
                Spacer()
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        //            .padding()
    }
}
