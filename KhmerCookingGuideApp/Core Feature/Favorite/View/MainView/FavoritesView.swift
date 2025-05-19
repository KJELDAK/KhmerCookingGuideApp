//
//  FavoritesView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 20/1/25.
//

import SwiftUI

struct FavoritesView: View {
    @StateObject var favoriteViewModel = FavoriteViewModel()
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            VStack {
                if favoriteViewModel.favoriteList.isEmpty {
                    // Empty State
                    VStack {
                        Image(systemName: "star")
                            .font(.system(size: 64))
                            .foregroundColor(.gray)
                        Text("no_favorites_yet")
                            .customFontMediumLocalize(size: 18)
                            .padding(.top)
                        Text("start_exploring_text")
                            .customFontLocalize(size: 16)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .padding()
                        ButtonComponent(action: {
                            selectedTab = 1
                        }, content: "discover_recipes")
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteViewModel.favoriteList.indices, id: \.self) { index in
                                let recipe = favoriteViewModel.favoriteList[index]
                                if let firstPhoto = recipe.photo.first {
                                    NavigationLink(
                                        destination: RecipeDetails(isLike: $favoriteViewModel.favoriteList[index].isFavorite, id: recipe.id).navigationBarHidden(true)
                                    ) {
                                        FoodCardComponent2(id: recipe.id,
                                                           isFavorite: $favoriteViewModel.favoriteList[index].isFavorite,
                                                           fileName: firstPhoto.photo,
                                                           name: recipe.name,
                                                           description: recipe.description, rating: recipe.averageRating ?? 0, level: recipe.level)
                                            .frame(maxWidth: .infinity)
                                            .padding(.horizontal)
                                    }.onChange(of: favoriteViewModel.favoriteList[index].isFavorite) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            favoriteViewModel.getAllFavoriteFoodRecipes { success, message in
                                                print("Fetch status: \(success), message: \(message)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                       
                    }.scrollIndicators(.hidden)
                       
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("favorites_title")
                        .customFontSemiBoldLocalize(size: 20)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                favoriteViewModel.getAllFavoriteFoodRecipes { success, message in
                    print("Fetch status: \(success), message: \(message)")
                }
            }

        }
    }
}

