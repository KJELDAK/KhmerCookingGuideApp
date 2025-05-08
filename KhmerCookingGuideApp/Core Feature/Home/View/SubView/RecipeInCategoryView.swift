//
//  RecipeInCategoryView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 7/2/25.
//

import SwiftUI

struct RecipeInCategoryView: View {
    var categoryId: Int
    @Environment(\.dismiss) var dismiss
    @StateObject var homeViewModel = HomeViewModel()
    @State private var searchQuery: String = ""

    var filteredRecipes: [FoodRecipeInCategory] {
        if searchQuery.isEmpty {
            return homeViewModel.RecipeInCategory
        } else {
            return homeViewModel.RecipeInCategory.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                    $0.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    if homeViewModel.RecipeInCategory.isEmpty {
                        SearchNotFoundComponent(content: "no_data")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        List {}.refreshable {
                            
                        }.listStyle(PlainListStyle())
                    } else if filteredRecipes.isEmpty {
                        SearchNotFoundComponent(content: "result_not_found")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        List {}.refreshable {
                            
                        }.listStyle(PlainListStyle())
                    }
                    ScrollView {
                        ForEach(filteredRecipes.indices, id: \.self) { index in
                            let recipe = filteredRecipes[index]

                            if let photoObj = recipe.photo.first {
                                let fileName = photoObj.photo
                                let isFav = Binding<Bool>(
                                    get: {
                                        homeViewModel.RecipeInCategory.first(where: { $0.id == recipe.id })?.isFavorite ?? false
                                    },
                                    set: { newValue in
                                        if let i = homeViewModel.RecipeInCategory.firstIndex(where: { $0.id == recipe.id }) {
                                            homeViewModel.RecipeInCategory[i].isFavorite = newValue
                                        }
                                    }
                                )

                                NavigationLink(
                                    destination: RecipeDetails(isLike: isFav, id: recipe.id)
                                        .navigationBarHidden(true)
                                ) {
                                    FoodCardComponent2(
                                        id: recipe.id,
                                        isFavorite: isFav,
                                        fileName: fileName,
                                        name: recipe.name,
                                        description: recipe.description,
                                        rating: recipe.averageRating ?? 0,
                                        level: recipe.level
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button {
//                                dismiss()
//                            } label: {
//                                Image(.backButton2)
//                            }
                                Button {
                                    dismiss()
                                } label: {
                                    Image("backButton")
                                }
                        }
                        ToolbarItem(placement: .principal) {
                            Text(categoryId == 1 ? "Breakfast" : categoryId == 2 ? "Lunch" : "Dinner")
                                .customFontSemiBoldLocalize(size: 20)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $searchQuery)
                }
            }
        }
        .onAppear {
            homeViewModel.getFoodByCategoryId(id: categoryId) { success, message in
                print(message)
            }
        }
    }
}
