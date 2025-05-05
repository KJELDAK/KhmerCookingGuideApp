//
//  RecipeEditorView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 19/1/25.
//
import SwiftUI

struct RecipeEditorView: View {
    @Binding var ingredients: [Ingredienth]
    @Binding var cookingSteps: [CookingStep]
    @State private var nextIngredientId: Int = 2
    @Environment(\.dismiss) var dismiss
    @Binding var isNavigateToPreviousView: Bool
    @Binding var foodName: String
    @Binding var foodDescription: String
    @Binding var isSheetPresent: Bool
    @ObservedObject var photoPicker: PhotoPicker
    @Binding var selectedTab: Int
    @StateObject var postFoodRecipeViewModel = PostFoodRecipeViewModel()
    @Binding var selectedLevel: String
    @Binding var selectedCuisines: String
    @Binding var selectedCategory: String
    @State var reqLevel: String = ""
    @State var reqCuisines = 1
    @State var reqCategory = 1
    @Binding var duration: Int
    @State var isPostRecipeSuccess: Bool = false
    @State var isPostRecipeFailed: Bool = false
    @State var messageFromServer: String = ""

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        SectionHeader(title: "ingredients")
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
                        SectionHeader(title: "step")

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

                            }, content: "_back")

                            ButtonComponent(action: {
                                logRecipeData()
                                print(photoPicker.prepareImageDataForAPI(), foodName, foodDescription)
                                print("Ingredients:", ingredients)
                                print("_hard:", cookingSteps, reqLevel)
                                switch selectedLevel {
                                case "_hard":
                                    reqLevel = "Hard"
                                case "_medium":
                                    reqLevel = "Medium"
                                case "_easy":
                                    reqLevel = "Easy"
                                default:
                                    reqLevel = "Easy" // Default value
                                }

                                switch selectedCategory {
                                case "_dinner":
                                    reqCategory = 3
                                case "_lunch":
                                    reqCategory = 2
                                default:
                                    reqCategory = 1
                                }
                                switch selectedCuisines {
                                case "_steam":
                                    reqCuisines = 7
                                case "_dessert":
                                    reqCuisines = 6
                                case "_stir-Fried":
                                    reqCuisines = 5
                                case "_fry":
                                    reqCuisines = 4
                                case "_grill":
                                    reqCuisines = 3
                                case "_salad":
                                    reqCuisines = 2
                                default:

                                    reqCuisines = 1
                                }
                                postFoodRecipeViewModel.uploadFiles(imageDataArray: photoPicker.prepareImageDataForAPI()) { success, message in
                                    if success {
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
                                            level: reqLevel,
                                            cuisineId: reqCuisines,
                                            categoryId: reqCategory,
                                            ingredients: ingredients,

                                            cookingSteps: cookingSteps
                                        )
                                        // Call API
                                        postFoodRecipeViewModel.postFoodRecipe(newFoodRecipe) { success, message in
                                            messageFromServer = message
                                            if success {
                                                isPostRecipeSuccess = true

                                                print(newFoodRecipe)
                                            } else {
                                                isPostRecipeFailed = true
                                                print(newFoodRecipe)
                                            }
                                        }
                                    } else {
                                        isPostRecipeFailed = true
                                        messageFromServer = "⚠️ Failed to post recipe, please try again later!"
                                    }
                                }

                            }, content: "_submit")
                                .disabled(
                                    ingredients.isEmpty ||
                                        cookingSteps.isEmpty ||
                                        ingredients.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                        ingredients.contains(where: { $0.quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                        cookingSteps.contains(where: { $0.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
                                )
                                .opacity(
                                    ingredients.isEmpty ||
                                        cookingSteps.isEmpty ||
                                        ingredients.contains(where: { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                                ingredients.contains(where: { $0.quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) ||
                                                cookingSteps.contains(where: { $0.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
                                        }) ? 0.4 : 1
                                )
                        }
                    }
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("_recipe")
                                .customFontSemiBoldLocalize(size: 20)
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                isSheetPresent = false
                                selectedTab = 0
                            }) {
                                Image("iconClose")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
            if postFoodRecipeViewModel.isLoading {
                LoadingComponent()
            } else {
                SuccessAndFailedAlert(status: true, message: LocalizedStringKey(messageFromServer), duration: 3, isPresented: $isPostRecipeSuccess)
                    .onDisappear {
                        isSheetPresent = false
                        selectedTab = 0
                    }
                SuccessAndFailedAlert(status: false, message: LocalizedStringKey(messageFromServer), duration: 3, isPresented: $isPostRecipeFailed)
                    .onDisappear {
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
                TextField("enter_ingredient", text: $Ingredienth.name)
                    .padding()
                    .font(.custom("KantumruyPro-Regular", size: 16))

                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.top)
            }

            HStack {
                NumericTextField(value: $Ingredienth.quantity, placeholder: "enter_ingredient_quantity")
            }
            .padding()
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "D0DBEA"), lineWidth: 2)
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
        _stepDescription = State(initialValue: step.description) // Initialize the description
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
                placeholder: "enter_step_description",
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
    let title: LocalizedStringKey

    var body: some View {
        Text(title)
            .customFontSemiBoldLocalize(size: 16)
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
struct Ingredienth: Codable, Identifiable {
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
        TextField(LocalizedStringKey(placeholder), text: $value)
//        .keyboardType(.decimalPad) // Use decimal keyboard
            .font(.custom("KantumruyPro-Regular", size: 16))
            .frame(height: 50)
            .padding(.horizontal)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "D0DBEA"), lineWidth: 2)
            )
    }
}
