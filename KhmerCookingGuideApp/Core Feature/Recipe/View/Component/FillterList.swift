//
//  FilterList.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 6/1/25.
//

import SwiftUI
struct FillterList: View {
    @StateObject var homeViewModel = HomeViewModel()
    @State var filters: [Cuisine] = []
    @State private var selectedFilter: String = "All"
    @Binding var cuisineId: Int
    @StateObject var recipeViewModel = RecipeViewModel()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(filters, id: \.self) { filter in
                    VStack {
                        Text(LocalizedStringKey(filter.cuisineName)) // Use categoryName for display
                            .foregroundColor(selectedFilter == filter.cuisineName ? .white : .gray)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedFilter == filter.cuisineName ? Color(hex: "primary"): Color.clear)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedFilter = filter.cuisineName
                                cuisineId = filter.id
                                // Compare with categoryName
                                print(selectedFilter, "this is cuisinId", cuisineId)
                            }
                    }
                }
            }
            .onAppear {
                homeViewModel.getAllCategories { isSucces, message in
                    print("hello")
                    if isSucces {
//                        filters = homeViewModel.categories
                        print("filters", filters)
//                        let all = CategoryResponsePayload(id: 999, categoryName: "All")
//                        filters.insert(all, at: 0)
                    }
                    else{
                        print("error hx")
                    }
                }
                recipeViewModel.getAllCuisine { success, message in
                    if success{
                        filters = recipeViewModel.cuision
                        print("filters", filters)
                        let all = Cuisine(id: 999, cuisineName: "All")
                        filters.insert(all, at: 0)
                        
                    }
                    else{
                        print("faild to get cuisine")
                    }
                }
                
            }
            .padding(.horizontal)
        }
    }
}
