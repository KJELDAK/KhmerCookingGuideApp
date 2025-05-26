//
//  AnimatedMeshGradientView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 22/5/25.
//


import SwiftUI

struct AnimatedMeshGradient: View {
    @State private var bluePosition: SIMD2<Float> = SIMD2<Float>(0.5, 0.5)
    @State private var index = 0
    let positions: [SIMD2<Float>] = [
        SIMD2<Float>(0.0, 0.0), SIMD2<Float>(0.5, 0.0), SIMD2<Float>(1.0, 0.0),
        SIMD2<Float>(1.0, 0.5), SIMD2<Float>(1.0, 1.0),
        SIMD2<Float>(0.5, 1.0), SIMD2<Float>(0.0, 1.0),
        SIMD2<Float>(0.0, 0.5), SIMD2<Float>(0.5, 0.5)
    ]
    var body: some View {
        if #available(iOS 18.0, *) {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], bluePosition, [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    
                    .pink, .pink, .green,
                    .blue, .white, .blue,
                    .blue, .pink, .blue,
                   
                ]
            )
            .overlay(
                VStack{
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black).opacity(0.5)
            )

            
            .ignoresSafeArea()
            .onAppear {
                // Start a timer to move the blue point every 1 second
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 9)) {
                        index = (index + 1) % positions.count
                        bluePosition = positions[index]
                    }
                }
            }
        } else {
            Text("iOS 18 or later required")
        }
    }
}

#Preview {
    AnimatedMeshGradient()
}

extension View {
    @ViewBuilder
    func themedBackground() -> some View {
        ZStack {
            AnimatedMeshGradient()
            self
        }
    }
}
