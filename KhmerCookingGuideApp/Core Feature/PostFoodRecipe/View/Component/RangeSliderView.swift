//
//  RangeSliderView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 17/1/25.
//

import SwiftUI

import SwiftUI
import SwiftUI

struct RangeSliderView: View {
    @Binding var requestDuration: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("_duration")
                .customFontMediumLocalize(size: 16)
                .foregroundColor(.black)

            HStack {
                Text("<5")
                    .font(.caption)
                    .foregroundColor(Color(hex: "primary"))
                
                Spacer()
                
                Text("\(requestDuration)")
                    .font(.headline)
                    .foregroundColor(Color(hex: "primary"))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                
                Text(">100")
                    .font(.caption)
                    .foregroundColor(Color(hex: "primary"))
            }

            Slider(value: Binding(
                get: { Double(requestDuration) },
                set: { requestDuration = Int($0) }
            ), in: 0...100, step: 1)
            .accentColor(Color(hex: "primary"))
        }
        .padding()
    }
}
//struct RangeSliderView: View {
//    @State private var duration: Double = 50 // Initial value
//    @Binding var requestDuration: Int
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("_duration")
//                .customFontMediumLocalize(size: 16)
//                .foregroundColor(.black)
//            
//            
//            
//            HStack {
//                Text("<5")
//                    .font(.caption)
//                    .foregroundColor(Color(hex: "primary"))
//                
//                Spacer()
//                
//                // Middle value
//                Text("\(Int(duration))")
//                    .font(.headline)
//                    .foregroundColor(Color(hex: "primary"))
//                    .frame(maxWidth: .infinity, alignment: .center) // Center the value
//                
//                Spacer()
//                
//                Text(">100")
//                    .font(.caption)
//                    .foregroundColor(Color(hex: "primary"))
//            }
//            
//            Slider(value: $duration, in: 0...100, step: 1) // Step value set to 1 for integers
//                .accentColor(Color(hex: "primary")) // Slider track color
////                .padding(.horizontal)
//                .onChange(of: duration) {
//                    requestDuration = Int(duration)
//                }
//                    
//                
//        }
//        .padding()
//    }
//}
