import SwiftUI

struct DateInputComponent: View {
    @Binding var placeHolder: String
    @Binding var image: String
    @State private var dateOfBirth: Date? = nil // Optional for initial empty state
    @Binding var requestDateOfBirth: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(image)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#374957"))
                
                ZStack(alignment: .leading) {
                    if dateOfBirth == nil {
                        Text(placeHolder)
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#757575"))
                    } else {
                        Text(dateOfBirth!.formatted(.dateTime.day().month().year()))
                            .customFont(size: 16)
                            .foregroundColor(Color(hex: "#090920"))
                          
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 36, maxHeight: 36, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color(hex: "#F9FAFB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
            )
            .overlay(alignment: .leading) {
                GeometryReader { geo in
                    DatePicker("", selection: Binding(
                        get: { dateOfBirth ?? Date() },
                        set: { newDate in dateOfBirth = newDate }
                    ), in: ...Date(), displayedComponents: .date)
                    .onChange(of: dateOfBirth) {
                        requestDateOfBirth = formatDateToString(dateOfBirth!)
                        
                    }
                    .scaleEffect(x: geo.size.width / 1, anchor: .topLeading)
                    .labelsHidden()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .leading)
                    .background(Color.clear)
                    .opacity(0.02) // Transparent for UI
                    .allowsHitTesting(true) // Enable interaction
                }
            }
        }
        .onAppear {
            dateOfBirth = nil // Set to nil on appear
        }
    }
    // MARK: - Helper function to formart date to string (format: 2024-01-11)
    func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        // Set the desired output format
        dateFormatter.dateFormat = "yyyy-MM-dd"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Set timezone if needed
        
        // Convert the Date to a formatted string
        return dateFormatter.string(from: date)
    }
}

//#Preview {
//    DateInputComponent(
//        placeHolder: .constant("Date of birth"),
//       
//        image: .constant("calendar")
//    )
//}
