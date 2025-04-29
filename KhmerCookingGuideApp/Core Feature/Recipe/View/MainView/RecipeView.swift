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
    
    @State var isSortByRating: Bool = false
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
                    .onChange(of: selectedType) {
                        if selectedType == "All"{
                            isSortByRating = false
                        }
                        else {
                            isSortByRating = true
                        }
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
                                ? searchAllFoodRecipes.sorted { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) }
                                : searchAllFoodRecipes
                                ForEach(sortedRecipes) { recipe in
                                    if let index = homeViewModel.foodRecipes.firstIndex(where: { $0.id == recipe.id }),
                                       let firstPhoto = recipe.photo.first {

                                        NavigationLink(
                                            destination: RecipeDetails(isLike:  $homeViewModel.foodRecipes[index].isFavorite, id: recipe.id).navigationBarHidden(true)
                                        ) {
                                            FoodCardComponent2(id: recipe.id,
                                                isFavorite: $homeViewModel.foodRecipes[index].isFavorite, // ✅ Bind it!
                                                fileName: firstPhoto.photo,
                                                name: recipe.name,
                                                               description: recipe.description, rating: recipe.averageRating ?? 0, level: recipe.level
                                            )
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
//                                let sortedRecipes = isSortByRating
//                                ? recipeViewModel.viewAllRecipeByCuisineId.sorted { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) }
//                                    : recipeViewModel.viewAllRecipeByCuisineId
                                let filteredRecipes = searchFoodRecipesByCuisineId
                                let sortedRecipes = isSortByRating
                                    ? filteredRecipes.sorted { ($0.averageRating ?? 0) > ($1.averageRating ?? 0) }
                                    : filteredRecipes


                                ForEach(sortedRecipes) { recipe in
                                    if let index = recipeViewModel.viewAllRecipeByCuisineId.firstIndex(where: { $0.id == recipe.id }),
                                       let firstPhoto = recipe.photo.first {

                                        let binding = Binding<Bool>(
                                            get: { recipeViewModel.viewAllRecipeByCuisineId[index].isFavorite },
                                            set: { newValue in
                                                recipeViewModel.viewAllRecipeByCuisineId[index].isFavorite = newValue
                                            }
                                        )

                                        NavigationLink(
                                            destination: RecipeDetails(isLike: binding, id: recipe.id).navigationBarHidden(true)
                                        ) {
                                            FoodCardComponent2(
                                                id: recipe.id,
                                                isFavorite: binding,
                                                fileName: firstPhoto.photo,
                                                name: recipe.name,
                                                description: recipe.description, rating: recipe.averageRating ?? 0, level: recipe.level
                                            )
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
            recipe.description.lowercased().contains(searchText.lowercased()) ||
            recipe.name.lowercased().contains(searchText.lowercased())
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
