import SwiftUI

struct SlideShowComponent: View {
    // Array of image names
    let images = ["mhob1", "mhob2", "mhob1", "mhob2"]

    // Timer for automatic slide transition
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(0 ..< images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .clipShape(Rectangle()) // Replace with the shape you want
                        .scaledToFill()
                        .tag(index) // Tag for identifying the selected tab
                }
            }
            .tabViewStyle(.page)
            .onReceive(timer) { _ in
                // Update currentIndex to show the next image
                withAnimation {
                    currentIndex = (currentIndex + 1) % images.count
                }
            }
            .cornerRadius(16)
            .frame(height: 160) // Adjusted height to 120

            // Custom dot indicator
        }
    }
}

#Preview {
    SlideShowComponent()
}

