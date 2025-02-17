//
//  FavoritesView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//


import SwiftUI

struct FavoritesView: View {
    @State private var favoriteRecipes: [Recipe] = [] // Replace with your data model

    var body: some View {
        NavigationView {
            VStack {
                if favoriteRecipes.isEmpty {
                    // Empty State
                    VStack {
                        Image(systemName: "star")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("No Favorites Yet")
                            .font(.headline)
                            .padding(.top)
                        Text("Start exploring delicious Khmer recipes and save your favorites here!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        ButtonComponent(action: {
                            
                        }, content: "Discover Recipes")
                    }
                    .padding()
                } else {
                    // List of Favorite Recipes
                    List(favoriteRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            HStack {
                                Image(recipe.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                VStack(alignment: .leading) {
                                    Text(recipe.name)
                                        .font(.headline)
                                    Text("\(recipe.cookingTime) minutes")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .navigationTitle("Favorites")
                }
            }
        }
    }
}

// Example Recipe Model
struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let cookingTime: Int
}

// Example Recipe Detail View
struct RecipeDetailView: View {
    let recipe: Recipe
    var body: some View {
        Text("Details for \(recipe.name)")
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
