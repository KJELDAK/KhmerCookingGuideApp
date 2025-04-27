//
//  CategoryView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 24/12/24.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    var body: some View {
        HStack{
            ScrollView(.horizontal){
                HStack{
                    ForEach(homeViewModel.categories){ category in
                        NavigationLink(destination: RecipeInCategoryView(categoryId: category.id).navigationBarHidden(true)) {
                            CategoryCardComponent(title: category.categoryName, image: "mhob7")
                        }
                        
                    }
                }
            }.scrollIndicators(.hidden)
        }
    }
}

