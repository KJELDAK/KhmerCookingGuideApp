//
//  AllImageInRecipe.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 6/1/25.
//

import SwiftUI
import Kingfisher
struct AllImageInRecipe: View {
     @State var image: [Photo] = []

    var body: some View {
        HStack {
            HStack{
                ForEach(image) { img in
                    Button(action: {
                        // Print when button is clicked and show photo ID
                        print("Button clicked: \(img.id), \(img.photo)")
                    }) {
                        Image(img.photo)
                            .resizable()
                            .frame(width: 34, height: 34) // Adjust the size for visibility
                    }
                    .frame(width: 34, height: 34)
                    .background(Color.blue)
                    .cornerRadius(7)
                    .padding(0)
                }
            }.padding(8)
            
        }
        .background(.white.opacity(0.3))
        .cornerRadius(14)
       
        .onAppear {
//            let photos = [
//                Photo(id: 999, photo: "mhob1"),
//                Photo(id: 1000, photo: "mhob2"),
//                Photo(id: 1001, photo: "mhob3"),
//                Photo(id: 1001, photo: "mhob3")
//            ]
//            image.append(contentsOf: photos)
            print(image)
        }
    }
}

#Preview {
    AllImageInRecipe()
}
