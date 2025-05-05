//
//  RecipeInCategoryView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 7/2/25.
//

import SwiftUI

//
// struct RecipeInCategoryView: View {
//     var categoryId : Int
//    @Environment(\.dismiss) var dismiss
//
//    @StateObject var homeViewModel = HomeViewModel()
//    var body: some View {
//        ZStack{
//
//            NavigationView {
//
//
//                VStack {
//                  ScrollView {
//                      ForEach($homeViewModel.RecipeInCategory) { $recipe in
//                      if let photoObj = recipe.photo.first {
//                        Group {
//                          // 1️⃣ extract the String
//                          let fileName = photoObj.photo
//
//                          // 2️⃣ map Bool? → Bool
//                          let isFav = Binding<Bool>(
//                            get:  { recipe.isFavorite ?? false },
//                            set: { recipe.isFavorite = $0 }
//                          )
//
//                          NavigationLink(
//                            destination:
//                              RecipeDetails(isLike: isFav, id: recipe.id)
//                                .navigationBarHidden(true)
//                          ) {
//                            FoodCardComponent2(
//                              id: recipe.id,
//                              isFavorite: isFav,
//                              fileName: fileName,
//                              name: recipe.name,
//                              description: recipe.description,
//                              rating: recipe.averageRating ?? 0, level: recipe.level
//                            )
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal)
//                          }
//                        }
//                      }
//                    }
//                  }
//                }
//
//
//
//                .padding()
//                .toolbar{
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button{
//                            dismiss()
//                        }label: {
//                            Image(.backButton2)
//
//                        }
//
//                    }
//                    ToolbarItem(placement: .principal) {
//                        Text(categoryId == 1 ? "Breakfast" : categoryId == 2 ? "Lunch" : "Dinner")
//                            .customFontRobotoBold(size: 16)
//                    }
//                }
//                .navigationBarTitleDisplayMode(.inline)
//
//            }
//        }
//        .onAppear{
//            homeViewModel.getFoodByCategoryId(id: categoryId) { success, message in
//                print("Success: \(success)")
//                print("Message: \(message)")
//            }
//        }
//
//    }
// }

import SwiftUI

import SwiftUI

// struct RecipeInCategoryView: View {
//    var categoryId: Int
//    @Environment(\.dismiss) var dismiss
//
//    @StateObject var homeViewModel = HomeViewModel()
//    @State private var searchQuery: String = "" // 1️⃣ Add search query state
//
//    var body: some View {
//        ZStack {
//            NavigationView {
//                VStack {
//                    // 2️⃣ Use the native searchable modifier
//                    ScrollView {
//                        ForEach($homeViewModel.RecipeInCategory) { $recipe in
//                            if let photoObj = recipe.photo.first {
//                                Group {
//                                    // Extract the String
//                                    let fileName = photoObj.photo
//
//                                    // Map Bool? → Bool
//                                    let isFav = Binding<Bool>(
//                                        get: { recipe.isFavorite ?? false },
//                                        set: { recipe.isFavorite = $0 }
//                                    )
//
//                                    NavigationLink(
//                                        destination: RecipeDetails(isLike: isFav, id: recipe.id)
//                                            .navigationBarHidden(true)
//                                    ) {
//                                        FoodCardComponent2(
//                                            id: recipe.id,
//                                            isFavorite: isFav,
//                                            fileName: fileName,
//                                            name: recipe.name,
//                                            description: recipe.description,
//                                            rating: recipe.averageRating ?? 0,
//                                            level: recipe.level
//                                        )
//                                        .frame(maxWidth: .infinity)
////                                        .padding(.horizontal)
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//                    .scrollIndicators(.hidden)
//                    .padding()
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarLeading) {
//                            Button {
//                                dismiss()
//                            } label: {
//                                Image(.backButton2)
//                            }
//                        }
//                        ToolbarItem(placement: .principal) {
//                            Text(categoryId == 1 ? "Breakfast" : categoryId == 2 ? "Lunch" : "Dinner")
//                                .customFontRobotoBold(size: 16)
//                        }
//                    }
//                    .navigationBarTitleDisplayMode(.inline)
//                    .searchable(text: $searchQuery) // 5️⃣ Add native search bar modifier
//                }
//            }
//        }
//        .onAppear {
//            homeViewModel.getFoodByCategoryId(id: categoryId) { success, message in
//                print("Success: \(success)")
//                print("Message: \(message)")
//            }
//        }
//    }
// }
struct RecipeInCategoryView: View {
    var categoryId: Int
    @Environment(\.dismiss) var dismiss

    @StateObject var homeViewModel = HomeViewModel()
    @State private var searchQuery: String = ""

    // 🔍 Computed property for filtered recipes
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
                            print("haha")
                        }.listStyle(PlainListStyle())
                    } else if filteredRecipes.isEmpty {
                        SearchNotFoundComponent(content: "result_not_found")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        List {}.refreshable {
                            print("haha")
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
                            Button {
                                dismiss()
                            } label: {
                                Image(.backButton2)
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
                print("Success: \(success)")
                print("Message: \(message)")
            }
        }
    }
}
