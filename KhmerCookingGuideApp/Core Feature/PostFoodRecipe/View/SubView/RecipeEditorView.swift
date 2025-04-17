//
//  RecipeEditorView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 19/1/25.
//

import SwiftUI

import SwiftUI

struct RecipeEditorView: View {
//    @State private var ingredients: [Ingredienth] = [Ingredienth(id: 1, name: "", quantity: "", price: "")]
//    @State private var cookingSteps: [CookingStep] = [CookingStep(id: 1, description: "")]
    @Binding var ingredients: [Ingredienth]  // Use Binding to persist ingredients
       @Binding var cookingSteps: [CookingStep]  // Use Binding to persist cooking steps
    @State private var nextIngredientId: Int = 2 // Tracks the next available Ingredient ID
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

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Ingredients Section
                        SectionHeader(title: "Ingredients")
                        
//                        ForEach(ingredients.indices, id: \.self) { index in
//                            IngredientInputView(
//                                Ingredienth: $ingredients[index],
//                                onDelete: {
//                                    ingredients.remove(at: index)
//                                }
//                            )
//                        }
                        ForEach(ingredients, id: \.id) { ingredient in
                            IngredientInputView(
                                Ingredienth: Binding(
                                    get: { ingredients.first(where: { $0.id == ingredient.id }) ?? ingredient },
                                    set: { newValue in
                                        if let index = ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                            ingredients[index] = newValue
                                        }
                                    }
                                ),
                                onDelete: {
                                    withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                                        ingredients.removeAll { $0.id == ingredient.id }
                                    }
                                }
                            )
//                            .transition(.asymmetric(
//                                   insertion: .move(edge: .trailing).combined(with: .opacity),
//                                   removal: .move(edge: .leading).combined(with: .opacity)
//                               ))
                            .transition(.scale(scale: 0.9).combined(with: .opacity))
                        }

                        
                        // Add Ingredient Button
                        AddButton {
                            withAnimation {
                                ingredients.append(
                                    Ingredienth(id: nextIngredientId, name: "", quantity: "", price: 0.0)
                                )
                                nextIngredientId += 1
                            }
                        }
                        
                        // Cooking Steps Section
                        SectionHeader(title: "Steps")
                        
//                        ForEach(cookingSteps) { step in
//                            CookingStepInputView(
//                                step: step,
//                                onUpdate: { updatedStep in
//                                    if let index = cookingSteps.firstIndex(where: { $0.id == step.id }) {
//                                        cookingSteps[index] = updatedStep
//                                    }
//                                },
//                                onDelete: {
//                                    // Delete the step and re-adjust IDs
//                                    if let index = cookingSteps.firstIndex(where: { $0.id == step.id }) {
//                                        cookingSteps.remove(at: index)
//                                        updateStepIds()
//                                    }
//                                }
//                            )
//                        }
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



                        
                        // Add Step Button
//                        AddButton {
//                            cookingSteps.append(
//                                CookingStep(id: cookingSteps.count + 1, description: "")
//                            )
//                        }
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
                                postFoodRecipeViewModel.uploadFiles(imageDataArray: photoPicker.prepareImageDataForAPI()) { success, message in
                                    if success{
                                        let fileNames = postFoodRecipeViewModel.image.map { url in
                                            (url as NSString).lastPathComponent
                                        }

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
                                            ingredients: ingredients
                                            ,
                                            cookingSteps: cookingSteps
                                        )

                                        // Call API
                                        postFoodRecipeViewModel.postFoodRecipe(newFoodRecipe) { success, message in
                                            messageFromServer = message
                                            if success {
                                                isPostRecipeSuccess = true
                                                print("🎉 Recipe successfully posted: \(message)")
                                                print(newFoodRecipe)
                                            } else {
                                                isPostRecipeFailed = true
                                                print("⚠️ Failed to post recipe: \(message)")
                                                print(newFoodRecipe)
                                            }
                                        }
                                    }
                                    else{
                                        isPostRecipeFailed = true
                                        messageFromServer = "⚠️ Failed to post recipe, please try again later!"
                                    }
                                }

                            }, content: "Submit")
                        }
                    }
                    .padding()
                    .navigationTitle("Recipe")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                isSheetPresent = false
                                selectedTab = 0
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                        }
                    }
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
                    }
                SuccessAndFailedAlert(status: false, message: messageFromServer, duration: 3, isPresented: $isPostRecipeFailed)
                    .onDisappear{
                        isSheetPresent = false
                        selectedTab = 0
                    }
            }
        }
    }
    
    // Function to re-adjust step IDs after deletion
    private func updateStepIds() {
        for index in cookingSteps.indices {
            cookingSteps[index].id = index + 1
        }
    }
    
    // Function to log data
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

struct IngredientInputView: View {
    @Binding var Ingredienth: Ingredienth
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                TextField("Enter Ingredienth", text: $Ingredienth.name)
                    .padding()

                
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            HStack {
//                TextField("Quantity", text: Binding(
//                    get: { String(Ingredienth.quantity) },
//                    set: { Ingredienth.quantity = Double($0) ?? 0 } // Convert String back to Double safely
//                ))
//                .frame(height: 50)
//                .padding(.horizontal)
//                .overlay {
//                    RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"), lineWidth: 2)
//                }
                NumericTextField(value: $Ingredienth.quantity ,placeholder: "Eter ingredient quantity")

                   
            }
            .padding()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"),lineWidth: 2)
        }
        .padding(.vertical, 8)
        
    }
}


struct CookingStepInputView: View {
    let step: CookingStep
    let onUpdate: (CookingStep) -> Void
    let onDelete: () -> Void

    @State private var stepDescription: String

    init(step: CookingStep, onUpdate: @escaping (CookingStep) -> Void, onDelete: @escaping () -> Void) {
        self.step = step
        self.onUpdate = onUpdate
        self.onDelete = onDelete
        self._stepDescription = State(initialValue: step.description) // Initialize the description
    }

    var body: some View {
        HStack(alignment: .top) {
            Text("\(step.id)")
                .font(.headline)
                .frame(width: 30, height: 30)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())

            TextEditorWithPlaceholder(
                text: $stepDescription,
                placeholder: "Enter step description",
                isTextBlack: .constant(true)
            )
            .onChange(of: stepDescription) { newValue in
                // Update the step's description when the text changes
                onUpdate(CookingStep(id: step.id, description: newValue))
            }
            .padding()
            .frame(height: 94)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "D0DBEA"), lineWidth: 2)
            }
            .overlay(alignment: .topTrailing) {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                .padding()
            }
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.vertical, 8)
    }
}

struct AddButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color(hex: "primary"))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// Data Model
struct Ingredienth : Codable, Identifiable {
    var id: Int
    var name: String
    var quantity: String
    var price: Double = 0.0
}
import SwiftUI

struct NumericTextField: View {
    @Binding var value: String
    var placeholder: String = ""
    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2 // Limit to 2 decimal places
        return formatter
    }()
    
    var body: some View {
        TextField(placeholder, text: $value)
//        .keyboardType(.decimalPad) // Use decimal keyboard
        .frame(height: 50)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "D0DBEA"), lineWidth: 2)
        )
    }
}
