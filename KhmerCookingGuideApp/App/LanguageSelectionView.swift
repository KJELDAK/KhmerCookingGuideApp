struct LanguageSelectionView: View {
    @Binding var isPermissionNotification: Bool
    @Binding var showLanguageSheet: Bool
    @Binding var selectedLanguage: String
    @State var Langeselected: String = UserDefaults.standard.string(forKey: "lang") ?? "English"
    @State var isLogout = false
    @Binding var isGetStart:Bool
    @Binding var lang: String
    
    func askNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                isGetStart = true
                DispatchQueue.main.async {
                    // Register for remote notifications
                    UIApplication.shared.registerForRemoteNotifications()
                }
                print("Notification permission granted.")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func handleSelected() {
        askNotificationPermission()
        isGetStart = true
        
        selectedLanguage = Langeselected

        switch(Langeselected) {
        case "Khmer":
            lang = "km"
        case "English":
            lang = "en"
        case "Korean":
            lang = "ko"
        default:
            break
        }
        
        //state to handle popUp Permission Notification
        isPermissionNotification = true
        
        showLanguageSheet = false
        
        UserDefaults.standard.set(selectedLanguage, forKey: "lang")
    }
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var body: some View {
        VStack(alignment: .center,spacing: 10) {
            Text("Language")
                .customFontBoldLocalize(size: 24)
            
            // Language selection options
            VStack(alignment: .leading,spacing: 15) {
                Text("Please select a display language")
                    .customFontLocalize(size: 18)
                    .foregroundColor(.gray)
                
                LanguageOption(language: "Khmer", flag: "khmerLogo", isSelected: $Langeselected)
                LanguageOption(language: "English", flag: "USLogo", isSelected: $Langeselected)
                LanguageOption(language: "Korean", flag: "KoreaLogo", isSelected: $Langeselected)
            }
            .padding(.top,10)
            
            // Select button
            ButtonComponent(action: {
                handleSelected()
            }, content: "Select")
            .padding(.bottom)
        }
        .padding(.top,30)
        .padding(.horizontal,20)
        .presentationDetents([screenWidth <= 375 ? .height(430) : .height(440),screenWidth <= 375 ? .height(435) : .medium])
        .presentationBackground(.white)
        .presentationCornerRadius(20)
        .background(Color.white)
        .cornerRadius(20)
    }

}