//
//  RecipeView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 5/1/25.
//

import SwiftUI

struct RecipeView: View {
    @State var searchText: String = ""
    @State var isPresented: Bool = false
    @State var selectedType: String = "All"
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var recipeViewModel = RecipeViewModel()
    @State var cuisineId : Int = 999
    @State var isSortByRating: Bool = true
    var body: some View {
        
        ZStack{
            VStack{
                HStack{
                   
                    Button{
                        isPresented.toggle()
                    }label: {
                        HStack{
                            Image("filter").resizable()
                                .frame(width: 24,height: 24)
                            Text("Filter")
    //                            .customFontMediumLocalize(size: 16)
                                .customFontRobotoMedium(size: 16)
                            
                        }.padding(.leading)
                    } .sheet(isPresented: $isPresented){
                        FoodRecipeFilterComponent(isPresented: $isPresented, selectedType: $selectedType)
                            .presentationDetents([.height(400), .height(405)])
                            .presentationBackground(.white)
                            .presentationCornerRadius(20)
                    }
                    .accentColor(.black)
                    SearchBarComponent(searchText: $searchText)
                }
                FillterList(cuisineId: $cuisineId)
                    .onChange(of: cuisineId) {
                        recipeViewModel.getAllFoodRecipeByCuisineId(cuisineId: cuisineId) { _, _ in
                            
                        }
                    }
                ZStack{
                    if cuisineId == 999{
                        if homeViewModel.isLoading{
                            ProgressView()
                        }
                        //MARK: - hanlde when search not found
                       else if homeViewModel.foodRecipes.isEmpty{
                           SearchNotFoundComponent(content: "No data")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            List{}.refreshable {
                                print("haha")
                            }.listStyle(PlainListStyle())

                        }
                        else if searchAllFoodRecipes.isEmpty{
                            SearchNotFoundComponent(content: "Result not found")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                List{}.refreshable {
                                    print("haha")
                                }.listStyle(PlainListStyle())

                        }
                        else{
                            ScrollView{
                                let sortedRecipes = isSortByRating
                                ? searchAllFoodRecipes.sorted { ($0.totalRaters ?? 0) > ($1.totalRaters ?? 0) }
                                : searchAllFoodRecipes
                                ForEach(/*homeViewModel.foodRecipes*/ sortedRecipes){ foodRecipe in
                                    // Ensure you only use the first photo from the photo array
                                    if let firstPhoto = foodRecipe.photo.first {
                                        NavigationLink(
                                            destination: RecipeDetails(id: foodRecipe.id).navigationBarHidden(true)
                                        ) {
                                            FoodCardComponent(isFavorite: foodRecipe.isFavorite, fileName: firstPhoto.photo, name: foodRecipe.name, description: foodRecipe.description)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }

                            }
                            }
                            .refreshable {
                                print("refresh")
                            }

                        }
                    }
                    else{
                        if recipeViewModel.isLoading{
                            ProgressView()
                        }
                        else if recipeViewModel.viewAllRecipeByCuisineId.isEmpty{
                            SearchNotFoundComponent(content: "No data")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                List{}.refreshable {
                                    print("haha")
                                }.listStyle(PlainListStyle())
                        }
                        else if searchFoodRecipesByCuisineId.isEmpty{
                            SearchNotFoundComponent(content: "Result not found")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                List{}.refreshable {
                                    print("haha")
                                }.listStyle(PlainListStyle())
                        }
                        else{
                            ScrollView {
                                let sortedRecipes = isSortByRating
                                    ? searchFoodRecipesByCuisineId.sorted { ($0.totalRaters ?? 0) > ($1.totalRaters ?? 0) }
                                    : searchFoodRecipesByCuisineId

                                ForEach(sortedRecipes) { foodRecipe in
                                    if let firstPhoto = foodRecipe.photo.first {
                                        NavigationLink(destination: RecipeDetails(id: foodRecipe.id).navigationBarHidden(true)) {
                                            FoodCardComponent(isFavorite: foodRecipe.isFavorite, fileName: firstPhoto.photo, name: foodRecipe.name, description: foodRecipe.description)
                                                .frame(maxWidth: .infinity)
                                        }
                                    }
                                }
                            }


                            .refreshable {
                                print("refresh")
                            }
                        }
                        
                    }
                }.padding([.horizontal, .top])
                Spacer()
            }
        }
        .onAppear{
            homeViewModel.getAllFoodRecipes { isSccess, message in
                print("get bannnnn")
            }
            recipeViewModel.getAllFoodRecipeByCuisineId(cuisineId: cuisineId) { success, message in
                if success {
                    print("get data ban hx")
                }
            }
            
        }
    }
    var searchFoodRecipesByCuisineId: [FoodRecipeByCuisine] {
        guard !searchText.isEmpty else { return recipeViewModel.viewAllRecipeByCuisineId }
        
        return recipeViewModel.viewAllRecipeByCuisineId.filter { recipe in
            recipe.description.lowercased().contains(searchText.lowercased())
        }
    }
    var searchAllFoodRecipes: [FoodRecipe] {
        guard !searchText.isEmpty else{ return homeViewModel.foodRecipes}
        return homeViewModel.foodRecipes.filter{ recipe in
            recipe.description.lowercased().contains(searchText.lowercased()) ||
            recipe.name.lowercased().contains(searchText.lowercased())
        }
    }

}

#Preview {
    RecipeView()
}
