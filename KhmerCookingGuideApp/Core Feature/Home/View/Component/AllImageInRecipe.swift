//
//  AllImageInRecipe.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 6/1/25.
//

import Kingfisher
import SwiftUI

struct AllImageInRecipe: View {
    @State var image: [Photo] = []

    var body: some View {
        HStack {
            HStack {
                ForEach(image) { img in
                    Button(action: {
                        print("Button clicked: \(img.id), \(img.photo)")
                    }) {
                        Image(img.photo)
                            .resizable()
                            .frame(width: 34, height: 34)
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
    }
}

#Preview {
    AllImageInRecipe()
}
