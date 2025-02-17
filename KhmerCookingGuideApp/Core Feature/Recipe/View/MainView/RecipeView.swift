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
    @StateObject var recipeViewModel = HomeViewModel()
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
                FillterList()
                VStack{
                    ScrollView{
                        ForEach(recipeViewModel.foodRecipes){ foodRecipe in
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
                }.padding([.horizontal, .top])
                Spacer()
            }
        }
        .onAppear{
            recipeViewModel.getAllFoodRecipes { isSccess, message in
                print("get bannnnn")
            }
        }
    }
}

#Preview {
    RecipeView()
}
