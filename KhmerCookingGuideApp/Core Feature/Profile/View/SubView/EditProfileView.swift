struct EditProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss

    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        let imageUrl = "\(API.baseURL)/fileView/"
        
        NavigationView {
            VStack(spacing: 16) {
                ZStack {
                    if profileViewModel.userInfo?.payload.profileImage != "default.jpg" {
                        KFImage(URL(string: imageUrl + (profileViewModel.userInfo?.payload.profileImage ?? "")))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("defaultPFMale")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    // Lock Icon Overlay
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        )
                        .offset(x: 35, y: 35)
                }
                .padding(.top)

                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Full Name")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Full Name", text: $fullName)
                            .textFieldStyle(.roundedBorder)
                    }

                    VStack(alignment: .leading) {
                        Text("Email Address")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Email Address", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                    }

                    VStack(alignment: .leading) {
                        Text("Phone Number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Phone Number", text: $phoneNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.phonePad)
                    }
                }
                .padding()

                Spacer()

                Button(action: {
                    saveProfile()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit Profile")
                        .customFontRobotoBold(size: 16)
                }
            }
            .onAppear {
                if let payload = profileViewModel.userInfo?.payload {
                    fullName = payload.fullName
                    email = payload.email
                    phoneNumber = payload.phoneNumber
                }
            }
        }
    }

    private func saveProfile() {
        profileViewModel.updateProfile(fullName: fullName, email: email, phoneNumber: phoneNumber) { success in
            if success {
                dismiss()
            } else {
                // Handle error (show alert, etc.)
            }
        }
    }
}
