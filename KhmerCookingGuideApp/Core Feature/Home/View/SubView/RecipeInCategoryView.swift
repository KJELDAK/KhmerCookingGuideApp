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
      

                VStack {
                  ScrollView {
                      ForEach($homeViewModel.RecipeInCategory) { $recipe in
                      if let photoObj = recipe.photo.first {
                        Group {
                          // 1️⃣ extract the String
                          let fileName = photoObj.photo
                          
                          // 2️⃣ map Bool? → Bool
                          let isFav = Binding<Bool>(
                            get:  { recipe.isFavorite ?? false },
                            set: { recipe.isFavorite = $0 }
                          )
                          
                          NavigationLink(
                            destination:
                              RecipeDetails(isLike: isFav, id: recipe.id)
                                .navigationBarHidden(true)
                          ) {
                            FoodCardComponent2(
                              id: recipe.id,
                              isFavorite: isFav,
                              fileName: fileName,
                              name: recipe.name,
                              description: recipe.description,
                              rating: recipe.averageRating ?? 0, level: recipe.level
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                          }
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

