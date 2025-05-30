//
//  PostFoodRecipeView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 16/1/25.
//

import SwiftUI
import PhotosUI
import Alamofire
import UIKit

struct PostFoodRecipeView: View {
    @State private var ingredients: [Ingredienth] = [Ingredienth(id: 1, name: "", quantity: "", price: 0)]
     @State private var cookingSteps: [CookingStep] = [CookingStep(id: 1, description: "")]
    @StateObject private var photoPicker = PhotoPicker()
    @State var foodName = ""
    @State var foodDescription = ""
    @State var food : String = ""
//    @State var isPostRecipeSuccess: Bool = false
//    @State var isPostRecipeFailed: Bool = false
//    @State var messageFromServer: String = ""
    @Binding var isSheetPresent: Bool
    @Binding var selectedTab : Int
    let columns: [GridItem] = [
        GridItem(.flexible()),  // Column 1
        GridItem(.flexible()),  // Column 2
        GridItem(.flexible())   // Column 3
    ]
    // State for each toggle group
    @State  var selectedLevel: String = "_hard"
    @State  var selectedCuisines: String = "_soup"
    @State  var selectedCategory: String = "_breakfast"
    @State var isRecipeInputation = false
    @State var isNavigateToPreviouseView = false
    @StateObject var postFoodRecipeViewModel = PostFoodRecipeViewModel()
    @State var duration: Int = 50
    var body: some View {
        ZStack{
            if isRecipeInputation{
                RecipeEditorView(ingredients: $ingredients,cookingSteps: $cookingSteps,isNavigateToPreviousView: $isNavigateToPreviouseView, foodName: $foodName, foodDescription: $foodDescription,isSheetPresent: $isSheetPresent, photoPicker: photoPicker, selectedTab: $selectedTab, selectedLevel: $selectedLevel,selectedCuisines: $selectedCuisines, selectedCategory: $selectedCategory, duration: $duration)
                    .onChange(of: isNavigateToPreviouseView) { isRecipeInputation = false
                        isNavigateToPreviouseView = false
                    }
            }
            else{
                ZStack {
                    NavigationView {
                        ScrollView{
                            VStack(alignment: .leading) {
                                // PhotosPicker for selecting multiple images
                                PhotosPicker(
                                    selection: $photoPicker.imageSelections,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    ZStack {
                                        VStack {
                                            // Only display images in the box when they are selected
                                            if !photoPicker.selectedImages.isEmpty {
                                                //                                ScrollView {
                                                LazyVGrid(columns: columns, spacing: 10) {
                                                    ForEach(Array(photoPicker.selectedImages.enumerated()), id: \.element) { index, image in
                                                        ZStack(alignment: .topTrailing) {
                                                            Image(uiImage: image)
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 100, height: 100)
                                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                .overlay(
                                                                    RoundedRectangle(cornerRadius: 10)
                                                                        .stroke(Color.white, lineWidth: 4)
                                                                )
                                                            
                                                            // Add a delete button
                                                            Button {
                                                                photoPicker.removeImage(at: index)
                                                            } label: {
                                                                Image(systemName: "xmark.circle.fill")
                                                                    .foregroundColor(.red)
                                                                    .background(Circle().fill(Color.white))
                                                                    .offset(x: -5, y: 5)
                                                            }
                                                        }
                                                    }
                                                }
                                                .padding(.vertical)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 2)
                                                        .overlay {
                                                            RoundedRectangle(cornerRadius: 16)
                                                                .stroke(
                                                                    Color(hex: "#E5E7EB"),
                                                                    style: StrokeStyle(
                                                                        lineWidth: 2,
                                                                        lineCap: .round,
                                                                        lineJoin: .round,
                                                                        dash: [10, 5]
                                                                    )
                                                                )
                                                        }
                                                )
                                                .padding(.bottom, 16)
                                                
                                            } else {
                                                // Placeholder if no images are selected
                                                VStack{
                                                    Image(systemName: "photo.on.rectangle")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundColor(.gray)
                                                        .padding()
                                                    Text("Add dishes Photo")
                                                        .customFontRobotoBold(size: 15)
                                                        .foregroundColor(.black.opacity(0.6))
                                                    Text("(Up to 12 Mb)")
                                                        .customFontRobotoMedium(size: 12)
                                                        .foregroundColor(.black.opacity(0.6))
                                                }.frame(maxWidth: .infinity)
                                                    .cornerRadius(16)
                                                    .padding()
                                                  
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E5E7EB") ,  style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                                                    }
                                                    .padding(.bottom)
                                            }
                                        }
                                    }
                                    .padding(.top)
                                }
                                //                .frame(height: 250)
                                //                    .background(.red)
                                .disabled(photoPicker.isImageLimitReached && photoPicker.selectedImages.isEmpty) // Disable PhotosPicker only when limit is reached and no images are selected
                                .onChange(of: photoPicker.imageSelections) { _ in
                                    Task {
                                        await photoPicker.loadImages()
                                    }
                                }

                                // Show a message if the limit is reached
                                if photoPicker.isImageLimitReached {
                                    Text("_you_can_only_select_up_to_5_images")
                                        .customFontLocalize(size: 14)
                                        .foregroundColor(.red)
                                        .padding(.top)
                                      
                                }
                                //MARK: - Food Name
                                Text("food_name")
                                    .customFontMediumLocalize(size: 16)
                                 
                                
                                TextField("enter_food_name", text: $foodName)
                                    .font(.custom("KantumruyPro-Regular", size: 16))
                                    .frame(height: 56)
                                    .padding(.horizontal)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"),lineWidth: 2)
                                    }
                                //MARK: - Description
                                Text("_description")
                                    .customFontMediumLocalize(size: 16)
                                    .padding(.top)
                                TextEditorWithPlaceholder(text:$foodDescription, placeholder: "tell_me_about_your_food", isTextBlack: .constant(true))
                                    .frame(height: 112)
                                    .padding(.horizontal)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"),lineWidth: 2)
                                    }
                                Spacer()
                            }.padding(.horizontal)
                                .toolbar{
                                    ToolbarItem(placement: .navigationBarLeading){
                                        Button{
                                            isSheetPresent = false
                                            selectedTab = 0
                                        }label: {
                                            Image("iconClose")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                        }
                                          
                                    }
                                    ToolbarItem(placement: .principal){
                                        Text("your_dishes")
                                            .customFontSemiBoldLocalize(size: 20)
                                    }
                                }
                                .navigationBarTitleDisplayMode(.inline)

                            //MARK: - Duration
                            RangeSliderView(requestDuration: $duration)
                            //MARK: - Level
                            VStack(alignment: .leading, spacing: 16) {
                                // Level (Single Selection)
                                ToggleButtonGroup(
                                    title: "_level",
                                    items: ["_hard", "_medium", "_easy"],
                                    selection: $selectedLevel,
                                    isSingleSelection: true
                                )
                              
                                
                                // Cuisines (Multi-Selection)
                                ToggleButtonGroup(
                                    title: "_cuisines",
                                    items: ["_soup", "_salad", "_grill","_fry","_stir_fried", "_dessert"],
                                    selection: $selectedCuisines,
                                    isSingleSelection: true
                                )
                                
                                // Category (Single Selection)
                                ToggleButtonGroup(
                                    title: "category",
                                    items: ["_breakfast", "_lunch", "_dinner"],
                                    selection: $selectedCategory,
                                    isSingleSelection: true
                                )
                                
                                ButtonComponent(action: {
                                    isRecipeInputation = true
//                                    let imageData = photoPicker.prepareImageDataForAPI()
                                }, content: "_next")
                                .disabled(foodName.isEmpty || foodDescription.isEmpty || photoPicker.prepareImageDataForAPI().isEmpty
)
                                .opacity(foodName.isEmpty || foodDescription.isEmpty || photoPicker.prepareImageDataForAPI().isEmpty
? 0.2 : 1)
                                .padding(.top)
                                
                                
                            }.padding()
                            
                            
                        }
                        
                    }
                }
                
                .onAppear {
                    print("sdvhb", selectedTab,selectedLevel)
                }
            }
         


        }
    }
    
}

struct BoxHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

@MainActor
final class PhotoPicker: ObservableObject {
    @Published var selectedImages: [UIImage] = [] // Store multiple selected images
    @Published var imageSelections: [PhotosPickerItem] = [] // Store multiple selected items
    
    private let maxImages = 5 // Limit to 5 images
    
    // Load images from the selected PhotosPickerItems
    func loadImages() async {
        // If the number of selected images is less than the max, allow loading new images
        guard selectedImages.count < maxImages else { return }
        
        for item in imageSelections {
            if selectedImages.count >= maxImages { break } // Stop loading if max is reached
            
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                if !selectedImages.contains(uiImage) { // Avoid duplicates
                    selectedImages.append(uiImage)
                }
            }
        }
    }
    
    // Check if the image limit is reached
    var isImageLimitReached: Bool {
        selectedImages.count >= maxImages
    }
    
    // Remove an image by index
    func removeImage(at index: Int) {
        guard index >= 0 && index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    // Prepare image data for API
    func prepareImageDataForAPI() -> [Data] {
        let imageDataArray = selectedImages.compactMap { image -> Data? in
            guard let imageData = image.jpegData(compressionQuality: 0.1) else { return nil }
            
            // Print the size of the image data
            print("Image Data Size: \(imageData.count) bytes")  // Prints the size of the data in bytes
            
            return imageData
        }
        
        return imageDataArray
    }
}
