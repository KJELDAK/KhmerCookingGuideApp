//
//  FoodView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 4/1/25.
//

import SwiftUI

//struct PopularFoodRecipes: View {
//    @ObservedObject var homeViewModel: HomeViewModel
//    var body: some View {
//        HStack{
//            ScrollView(.horizontal){
//                HStack{
//                    ForEach(homeViewModel.foodRecipes){ foodRecipe in
//                        ForEach(foodRecipe.photo){ photo in
//                            NavigationLink(destination: RecipeDetails(id: foodRecipe.id).navigationBarHidden(true)){
//                                FoodCardComponent(fileName: photo.photo, name: foodRecipe.description)
//                                    .frame(maxWidth: 300)
//                            }
//
//                        }
//                        
//                    }
//                }
//            }.scrollIndicators(.hidden)
//        }
//
//    }
//}
struct PopularFoodRecipes: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                   
                    ForEach(homeViewModel.popularRecipes) { foodRecipe in
                        // Ensure you only use the first photo from the photo array
                        if let firstPhoto = foodRecipe.photo.first {
                            NavigationLink(
                                destination: RecipeDetails(id: foodRecipe.id).navigationBarHidden(true)
                            ) {
                                FoodCardComponent(fileName: firstPhoto.photo, name: foodRecipe.name, description: foodRecipe.description)
                                    .frame(width: 300)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}


//#Preview {
//    FoodView()
//}
