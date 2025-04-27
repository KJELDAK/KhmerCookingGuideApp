//
//  HomeScreenView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 23/12/24.
//

import SwiftUI
struct HomeScreenView : View {
    @StateObject var homeViewModel = HomeViewModel()
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedTab: Int
    var body: some View {
        VStack(alignment: .leading,spacing: 16){
            HStack{
                VStack(alignment: .leading){
                    Group{
                        Text("what_would_you_like")
                        Text("to_eat_today?")
                            .padding(.top,-10)
                    } .customFontSemiBoldLocalize(size: 24)
                }
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 86, height: 48)
                    .scaledToFit()
            }
//            .customFontRobotoMedium(size: 24)
           
            SlideShowComponent()
            Text("category")
                .customFontSemiBoldLocalize(size: 16)
//                .customFontRobotoMedium(size: 16)
            CategoryView(homeViewModel: homeViewModel)
            VStack{
                HStack{
                    Text("popular_dishes")
//                        .customFontRobotoMedium(size: 16)
                        .customFontSemiBoldLocalize(size: 16)
                    Spacer()
                    Button{
                        selectedTab = 1
                    }label: {
                        HStack{
                            Text("view_all")
                                .foregroundColor(Color(hex: "FF0000"))
                                .customFontSemiBoldLocalize(size: 16)
//                                .customFontRobotoMedium(size: 16)
                            Image("arrow")
                        }
                    }
                }
                PopularFoodRecipes(popularRecipes: $homeViewModel.foodRecipes)

                    .padding(.top)
            }.padding(.top)
                
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
            .onAppear{
                homeViewModel.getPopularFoods { isSuccess, message  in
                    print(message)
                }
                homeViewModel.getAllCategories { isSuccess, message in
                    print(message)
                }
                homeViewModel.getAllFoodRecipes { success, message in
                    print(message)
                }
            }
    }
}
