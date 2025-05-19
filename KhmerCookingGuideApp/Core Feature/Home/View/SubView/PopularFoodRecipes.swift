//
//  PopularFoodRecipes.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 4/1/25.
//

import SwiftUI

struct PopularFoodRecipes: View {
    @Binding var popularRecipes: [FoodRecipe]

    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach($popularRecipes) { $foodRecipe in
                        NavigationLink(
                            destination: RecipeDetails(isLike: $foodRecipe.isFavorite, id: foodRecipe.id).navigationBarHidden(true)
                        ) {
                            FoodCardComponent2(
                                id: foodRecipe.id,
                                isFavorite: $foodRecipe.isFavorite, // Pass binding here
                                fileName: foodRecipe.photo.first?.photo ?? "",
                                name: foodRecipe.name,
                                description: foodRecipe.description, rating: foodRecipe.averageRating ?? 0, level: foodRecipe.level
                            )
                            .frame(width: 300)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}
