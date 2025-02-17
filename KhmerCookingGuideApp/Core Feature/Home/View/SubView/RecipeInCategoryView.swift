//
//  RecipeInCategoryView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 7/2/25.
//

import SwiftUI

struct RecipeInCategoryView: View {
     var categoryId : Int
    @Environment(\.dismiss) var dismiss
    
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        ZStack{
            
            NavigationView {

                VStack{
                    ScrollView{
                        ForEach(homeViewModel.RecipeInCategory){ foodRecipe in
            //                            ForEach(foodRecipe.photo) { photo in
            //                                FoodCardComponent(fileName: photo.photo, name: foodRecipe.description)
            //                                    .frame(maxWidth: .infinity)
            //                            }
                            // Ensure you only use the first photo from the photo array
                            if let firstPhoto = foodRecipe.photo.first {
                                NavigationLink(
                                    destination: RecipeDetails(id: foodRecipe.id).navigationBarHidden(true)
                                ) {
                                    FoodCardComponent(fileName: firstPhoto.photo, name: foodRecipe.name, description: foodRecipe.description)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }

                }
                .padding()
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button{
                            dismiss()
                        }label: {
                            Image(.backButton2)
                                
                        }
                        
                    }
                    ToolbarItem(placement: .principal) {
                        Text(categoryId == 1 ? "Breakfast" : categoryId == 2 ? "Lunch" : "Dinner")
                            .customFontRobotoBold(size: 16)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
        .onAppear{
            homeViewModel.getFoodByCategoryId(id: categoryId) { success, message in
                print("Success: \(success)")
                print("Message: \(message)")
            }
        }

    }
}

