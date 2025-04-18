//
//  HomeScreenView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 23/12/24.
//

import SwiftUI
struct HomeScreenView : View {
    @StateObject var homeViewModel = HomeViewModel()
    @Binding var selectedTab: Int
    var body: some View {
        VStack(alignment: .leading,spacing: 16){
            Group{
                Text("What would you like ")
                Text("to eat today ?")
                    .padding(.top,-10)
            }
            .customFontRobotoMedium(size: 24)
            SlideShowComponent()
//                .padding(.horizontal, -16)
            Text("Category")
                .customFontRobotoMedium(size: 16)
            CategoryView(homeViewModel: homeViewModel)
            VStack{
                HStack{
                    Text("Popular Dishes")
                        .customFontRobotoMedium(size: 16)
                    Spacer()
                    Button{
                        selectedTab = 1
                    }label: {
                        HStack{
                            Text("View all")
                                .foregroundColor(Color(hex: "FF0000"))
                                .customFontRobotoMedium(size: 16)
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
//#Preview {
//    HomeScreenView()
//}
