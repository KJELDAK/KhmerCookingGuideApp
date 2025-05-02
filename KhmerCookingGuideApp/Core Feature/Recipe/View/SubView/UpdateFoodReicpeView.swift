//
//  UpdateFoodReicpeView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 29/4/25.
//

import SwiftUI
import PhotosUI
import Alamofire
import UIKit

struct UpdateFoodRecipeView: View {
    @State private var ingredients: [Ingredienth] = [Ingredienth(id: 1, name: "", quantity: "", price: 0)]
    @State private var cookingSteps: [CookingStep] = [CookingStep(id: 1, description: "")]
    @StateObject private var photoPicker = PhotoPicker()
    @State var foodName = ""
    @State var foodDescription = ""
    @State var isSheetPresent = false
    @State var selectedTab = 3
    @State var selectedLevel: String = "Hard"
    @State var selectedCuisines: String = "Soup"
    @State var selectedCategory: String = "Breakfast"
    @State var isRecipeInputation = false
    @State var isNavigateToPreviouseView = false
    @StateObject var postFoodRecipeViewModel = PostFoodRecipeViewModel()
    
    @State private var apiImages: [UIImage] = []
    @State private var selectedApiImageIndices: Set<Int> = []
    @State private var originalApiImages: [String] = []
    @State private var hasFetched = false

    @Environment(\.dismiss) var dismiss
    
    
    
    @State var duration: Int = 50
    var foodId : Int
    
    let columns: [GridItem] = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    @ObservedObject var recipeViewModel : RecipeViewModel
    
    var body: some View {
        ZStack {
            if isRecipeInputation {
                UpdateRecipeEditorView(
                    ingredients: $ingredients,
                    cookingSteps: $cookingSteps,
                    isNavigateToPreviousView: $isNavigateToPreviouseView,
                    foodName: $foodName,
                    foodDescription: $foodDescription,
                    isSheetPresent: $isSheetPresent,
                    photoPicker: photoPicker,
                    selectedTab: $selectedTab,
                    selectedLevel: $selectedLevel,
                    selectedCuisines: $selectedCuisines,
                    selectedCategory: $selectedCategory,
                    duration: $duration, originalApiImages: $originalApiImages, apiImages: $apiImages, recipeViewModel: recipeViewModel, foodId: foodId
                )
                .onChange(of: isNavigateToPreviouseView) {
                    isRecipeInputation = false
                    isNavigateToPreviouseView = false
                }
            } else {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .leading) {
                            // MARK: - Photo Picker Section
                            PhotosPicker(
                                selection: $photoPicker.imageSelections,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                ZStack {
                                    if !photoPicker.selectedImages.isEmpty {
                                        photoGrid(allowDelete: true)
                                        
                                    } else if !apiImages.isEmpty {
                                        photoGrid(allowDelete: true)
                                        
                                    } else {
                                        placeholderView
                                    }
                                }
                            }
                            .disabled(photoPicker.isImageLimitReached && photoPicker.selectedImages.isEmpty)
                            .onChange(of: photoPicker.imageSelections) { _ in
                                Task { await photoPicker.loadImages() }
                            }
                            
                            if photoPicker.isImageLimitReached {
                                Text("You can only select up to 5 images.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.top)
                            }
                            
                            // MARK: - Food Name
                            Text("food_name")
                                .customFontMediumLocalize(size: 16)
                            TextField("Enter food name", text: $foodName)
                                .font(.custom("KantumruyPro-Regular", size: 16))
                                .frame(height: 56)
                                .padding(.horizontal)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"), lineWidth: 2))
                            
                            // MARK: - Description
                            Text("_description")
                                .customFontMediumLocalize(size: 16)
                            TextEditorWithPlaceholder(
                                text: $foodDescription,
                                placeholder: "Tell me a little about your food",
                                isTextBlack: .constant(true)
                            )
                            .frame(height: 112)
                            .padding(.horizontal)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"), lineWidth: 2))
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    isSheetPresent = false
                                    dismiss()
                                } label: {
                                    Image("iconClose")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            }
                            ToolbarItem(placement: .principal) {
                                Text("update_recipe")
                                    .customFontSemiBoldLocalize(size: 20)
                            }
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        
                        // MARK: - Duration
                        RangeSliderView(requestDuration: $duration)
                        
                        // MARK: - Level + Cuisine + Category
                        VStack(alignment: .leading, spacing: 16) {
                            ToggleButtonGroup(
                                title: "_level",
                                items: ["Hard", "Medium", "Easy"],
                                selection: $selectedLevel,
                                isSingleSelection: true
                            )
                            
                            ToggleButtonGroup(
                                title: "Cuisines",
                                items: ["Soup", "Salad", "Grill", "Fry", "Stir-Fried", "Dessert"],
                                selection: $selectedCuisines,
                                isSingleSelection: true
                            )
                            
                            ToggleButtonGroup(
                                title: "Category",
                                items: ["Breakfast", "Lunch", "Dinner", "Snack"],
                                selection: $selectedCategory,
                                isSingleSelection: true
                            )
                            
                            ButtonComponent(action: {
                                print("this is",originalApiImages)
                                handleSubmitRecipeUpdate()
                                isRecipeInputation = true
                            }, content: "Next")
                            .padding(.top)
                        }
                        .padding()
                    }
                }
                .onAppear {
                    // only fetch the very first time
                        guard !hasFetched else { return }
                        hasFetched = true
                    
                    recipeViewModel.fetchRecipeById(id: foodId) { success, _ in
                        if success {
                            guard success,
                                         let photos = recipeViewModel.viewRecipeById?.photo
                                   else { return }
                            foodName = recipeViewModel.viewRecipeById?.name ?? ""
                            foodDescription = recipeViewModel.viewRecipeById?.description ?? ""
                            selectedLevel = recipeViewModel.viewRecipeById?.level ?? ""
                            selectedCategory = recipeViewModel.viewRecipeById?.categoryName ?? ""
                            selectedCuisines = recipeViewModel.viewRecipeById?.cuisineName ?? ""
                            duration = recipeViewModel.viewRecipeById!.durationInMinutes
                            print("this is duration", duration)
                            
                            if let fetchedIngredients = recipeViewModel.viewRecipeById?.ingredients {
                                if let ingredienthList = fetchedIngredients as? [Ingredienth] {
                                    ingredients = ingredienthList
                                } else if let ingredientList = fetchedIngredients as? [Ingredient] {
                                    ingredients = ingredientList.map { $0.toIngredienth() }
                                }
                            }
                            cookingSteps = recipeViewModel.viewRecipeById?.cookingSteps ?? []

                                   originalApiImages = photos.map { $0.photo }
                                   // 2️⃣ Clear any previous UIImages
                                   apiImages = []
                                   // 3️⃣ Loop through each filename and fetch
                                   for filename in originalApiImages {
                                       guard let url = URL(string: "http://localhost:8080/api/v1/fileView/\(filename)")
                                       else { continue }

                                       fetchImage(from: url) { image in
                                           guard let image = image else { return }
                                           DispatchQueue.main.async {
                                               apiImages.append(image)
                                           }
                                       }
                                   }
                               }
                    }
                }
            }
        }
    }
    func handleSubmitRecipeUpdate() {
        //  Extract kept API image filenames
        var keptApiImageNames: [String] = []
        for (index, _) in apiImages.enumerated() {
            if index < originalApiImages.count {
                keptApiImageNames.append(originalApiImages[index])
            }
        }
        // ✅ Extract only new images to upload
        let newImagesToUpload = photoPicker.selectedImages
        
        print("✅ Keep these image filenames (already uploaded): \(keptApiImageNames)")
        print("📤 New images to upload: \(newImagesToUpload.count)")
        
    }
    @ViewBuilder
    func photoGrid(allowDelete: Bool) -> some View {
        let combinedImages = apiImages + photoPicker.selectedImages
        
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(combinedImages.enumerated()), id: \.offset) { index, image in
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
                    
                    if allowDelete {
                        Button {
                            if index < apiImages.count {
                                // Remove from apiImages
                                apiImages.remove(at: index)
                            } else {
                                // Remove from selectedImages
                                let localIndex = index - apiImages.count
                                photoPicker.removeImage(at: localIndex)
                            }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .background(Circle().fill(Color.white))
                                .offset(x: -5, y: 5)
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .background(RoundedRectangle(cornerRadius: 16).stroke(Color(hex: "#E5E7EB"), lineWidth: 2))
        .padding(.bottom)
    }
    // MARK: - Placeholder View
    var placeholderView: some View {
        VStack {
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
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#E5E7EB"), style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
        )
    }
    // MARK: - Load Image from URL
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                completion(UIImage(data: data))
            } else {
                completion(nil)
            }
        }.resume()
    }
}
// Extensions for conversion between Ingredient and Ingredienth
extension Ingredient {
    // Convert Ingredient to Ingredienth
    func toIngredienth() -> Ingredienth {
        return Ingredienth(id: self.id, name: self.name, quantity: self.quantity, price: self.price)
    }
}

extension Ingredienth {
    // Convert Ingredienth to Ingredient
    func toIngredient() -> Ingredient {
        return Ingredient(id: self.id, name: self.name, quantity: self.quantity, price: self.price)
    }
}
struct UpdateRecipeEditorView: View {
    @Binding var ingredients: [Ingredienth]
    @Binding var cookingSteps: [CookingStep]
    @Environment(\.dismiss) var dismiss
    @Binding var isNavigateToPreviousView: Bool
    @Binding var foodName: String
    @Binding var foodDescription: String
    @Binding var isSheetPresent: Bool
    @ObservedObject var photoPicker: PhotoPicker
    @Binding var selectedTab : Int
    @StateObject var postFoodRecipeViewModel = PostFoodRecipeViewModel()
    @Binding var selectedLevel : String
    @Binding var selectedCuisines : String
    @Binding var selectedCategory : String
    @State var reqLevel : String = ""
    @State var reqCuisines = 1
    @State var reqCategory = 1
    @Binding var duration : Int
    @State var isPostRecipeSuccess: Bool = false
    @State var isPostRecipeFailed: Bool = false
    @State var messageFromServer: String = ""
    @State private var nextIngredientId: Int = 0 // Set the initial value here, can be dynamically updated later
    @Binding var originalApiImages: [String] // All images from the API originally
    @Binding var apiImages: [UIImage]        // Only images still kept by the user
    @ObservedObject var recipeViewModel :RecipeViewModel
    var foodId : Int
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        SectionHeader(title: "ingredients")
                        ForEach(ingredients, id: \.id) { ingredient in
                            let ingredientBinding = Binding<Ingredienth>(
                                get: { ingredients.first(where: { $0.id == ingredient.id }) ?? ingredient },
                                set: { updatedIngredient in
                                    if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                        ingredients[index] = updatedIngredient
                                    }
                                }
                            )
                            IngredientInputView(
                                Ingredienth: ingredientBinding,
                                onDelete: {
                                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                                        ingredients.removeAll { $0.id == ingredient.id }
                                        // Recalculate the next ingredient ID
                                        nextIngredientId = (ingredients.map { $0.id }.max() ?? 0) + 1
                                    }
                                }
                            )
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                        }
                        
                        AddButton {
                            withAnimation {
                                ingredients.append(
                                    Ingredienth(id: nextIngredientId, name: "", quantity: "", price: 0.0)
                                )
                                // Dynamically calculate the next available ID after appending
                                nextIngredientId = (ingredients.map { $0.id }.max() ?? 0) + 1
                            }
                        }
                        // Cooking Steps Section
                        SectionHeader(title: "Steps")
                        
                        ForEach(cookingSteps) { step in
                            CookingStepInputView(
                                step: step,
                                onUpdate: { updatedStep in
                                    if let index = cookingSteps.firstIndex(where: { $0.id == step.id }) {
                                        cookingSteps[index] = updatedStep
                                    }
                                },
                                onDelete: {
                                    withAnimation(.easeInOut(duration: 0.4)) {
                                        if let index = cookingSteps.firstIndex(where: { $0.id == step.id }) {
                                            cookingSteps.remove(at: index)
                                            updateStepIds()
                                        }
                                    }
                                }
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                        }
                        AddButton {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                cookingSteps.append(
                                    CookingStep(id: cookingSteps.count + 1, description: "")
                                )
                            }
                        }
                        
                        
                        Spacer()
                        
                        HStack {
                            BackButtonComponent(action: {
                                isNavigateToPreviousView = true
                                
                            }, content: "Back")
                            
                            ButtonComponent(action: {
                                logRecipeData()
                                print(photoPicker.prepareImageDataForAPI(), foodName, foodDescription)
                                print("Ingredients:", ingredients)
                                print("Cooking Steps:", cookingSteps)
                                
                                switch selectedCategory{
                                case  "Dinner":
                                    reqCategory = 3
                                case "Lunch":
                                    reqCategory = 2
                                default:
                                    reqCategory = 1
                                }
                                switch selectedCuisines{
                                case "Steam":
                                    reqCuisines = 7
                                case "Dessert":
                                    reqCuisines = 6
                                case "Stir-Fried":
                                    reqCuisines = 5
                                case "Fry":
                                    reqCuisines = 4
                                case "Grill":
                                    reqCuisines = 3
                                case "Salad":
                                    reqCuisines = 2
                                default :
                                    
                                    reqCuisines = 1
                                }
                                let newImageData = photoPicker.prepareImageDataForAPI()
                                var keptApiImageNames: [String] = []
                                for (index, _) in apiImages.enumerated() {
                                    if index < originalApiImages.count {
                                        keptApiImageNames.append(originalApiImages[index])
                                    }
                                }
                                
                                if newImageData.isEmpty {
                                    // No new images, just post with kept ones
                                    let fileNames = keptApiImageNames
                                    let newFoodRecipe = PostFoodRequest(
                                        photo: fileNames.enumerated().map { index, fileName in
                                            Photo(id: index + 1, photo: fileName)
                                        },
                                        name: foodName,
                                        description: foodDescription,
                                        durationInMinutes: duration,
                                        level: selectedLevel,
                                        cuisineId: reqCuisines,
                                        categoryId: reqCategory,
                                        ingredients: ingredients,
                                        cookingSteps: cookingSteps
                                    )
                                    postFoodRecipeViewModel.updateFoodRecipeById(id: foodId,newFoodRecipe) { success, message in
                                        messageFromServer = message
                                        isPostRecipeSuccess = success
                                        isPostRecipeFailed = !success
                                    }
                                } else {
                                    // Upload new images, then combine with kept ones
                                    postFoodRecipeViewModel.uploadFiles(imageDataArray: newImageData) { success, message in
                                        if success {
                                            let uploadedFileNames = postFoodRecipeViewModel.image.map { url in
                                                (url as NSString).lastPathComponent
                                            }
                                            let fileNames = keptApiImageNames + uploadedFileNames
                                            let newFoodRecipe = PostFoodRequest(
                                                photo: fileNames.enumerated().map { index, fileName in
                                                    Photo(id: index + 1, photo: fileName)
                                                },
                                                name: foodName,
                                                description: foodDescription,
                                                durationInMinutes: duration,
                                                level: selectedLevel,
                                                cuisineId: reqCuisines,
                                                categoryId: reqCategory,
                                                ingredients: ingredients,
                                                cookingSteps: cookingSteps
                                            )
                                            postFoodRecipeViewModel.updateFoodRecipeById(id: foodId, newFoodRecipe) { success, message in
                                                messageFromServer = message
                                                isPostRecipeSuccess = success
                                                isPostRecipeFailed = !success
                                            }
                                        } else {
                                            isPostRecipeFailed = true
                                            messageFromServer = "⚠️ Failed to upload images, please try again!"
                                        }
                                    }
                                }
                                
                            }, content: "Submit")
                            .disabled(
                                ingredients.isEmpty ||
                                cookingSteps.isEmpty ||
                                ingredients.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                ingredients.contains(where: { $0.quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                cookingSteps.contains(where: {$0.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty})
                            )
                            .opacity(
                                ingredients.isEmpty ||
                                cookingSteps.isEmpty ||
                                ingredients.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                ingredients.contains(where: { $0.quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                cookingSteps.contains(where: {$0.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty})
                                }) ? 0.4 : 1
                            )

                        }
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                isSheetPresent = false
                                dismiss()
                            } label: {
                                Image("iconClose")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("update_recipe")
                                .customFontSemiBoldLocalize(size: 20)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)

                }
            }
            if postFoodRecipeViewModel.isLoading{
                LoadingComponent()
            }
            else{
                SuccessAndFailedAlert(status: true, message: messageFromServer, duration: 3, isPresented: $isPostRecipeSuccess)
                    .onDisappear{
                        isSheetPresent = false
                        selectedTab = 0
                        recipeViewModel.fetchRecipeById(id: foodId) { success, _ in
                            if success{
                                print("yes yes yes")
                            }
                        }
                        dismiss()
                        
                       
                    }
                SuccessAndFailedAlert(status: false, message: messageFromServer, duration: 3, isPresented: $isPostRecipeFailed)
                    .onDisappear{
                        isSheetPresent = false
                        selectedTab = 0
                    }
            }
        }.onAppear {
            nextIngredientId = (ingredients.map { $0.id }.max() ?? 0) + 1
        }
    }
    // Function to re-adjust step IDs after deletion
    private func updateStepIds() {
        for index in cookingSteps.indices {
            cookingSteps[index].id = index + 1
        }
    }
    private func logRecipeData() {
        print("=== Ingredients ===")
        for Ingredienth in ingredients {
            print("Name: \(Ingredienth.name), Quantity: \(Ingredienth.quantity), Price: \(Ingredienth.price)")
        }
        print("=== Cooking Steps ===")
        for step in cookingSteps {
            print("ID: \(step.id), Description: \(step.description)")
        }
    }
}
