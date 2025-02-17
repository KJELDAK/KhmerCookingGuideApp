//
//  FontConfiguration.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 9/12/24.
//

import SwiftUI

import SwiftUI

//struct CustomFontLocalization: ViewModifier {
//    var size: CGFloat
//    @Environment(\.locale) var local
//    
//    func body(content: Content) -> some View {
//        content
//            .font(.custom(local.identifier == "km" ? "KantumruyPro-Regular" : local.identifier == "en" ? "Roboto-Regular" : "NotoSansKR-Regular", size: size))
//    }
//}
//
//struct CustomFontMediumLocalization: ViewModifier {
//    var size: CGFloat
//    @Environment(\.locale) var local
//    func body(content: Content) -> some View {
//        content
//            .font(.custom(local.identifier == "km" ? "KantumruyPro-Medium" : local.identifier == "en" ? "Roboto-Medium" : "NotoSansKR-Medium", size: size))
//    }
//}
//
//struct CustomFontSemiblodLocalization: ViewModifier {
//    var size: CGFloat
//    @Environment(\.locale) var local
//    func body(content: Content) -> some View {
//        content
//            .font(.custom(local.identifier == "km" ? "KantumruyPro-SemiBold" : local.identifier == "en" ? "Roboto-Medium" : "NotoSansKR-SemiBold", size: size))
//    }
//}
//
//struct CustomFontBoldLocalization: ViewModifier {
//    var size: CGFloat
//    @Environment(\.locale) var local
//    func body(content: Content) -> some View {
//        content
//            .font(.custom(local.identifier == "km" ? "KantumruyPro-Bold" : local.identifier == "en" ? "Roboto-Black" : "NotoSansKR-Bold", size: size))
//    }
//}

struct CustomFontModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter_18pt-Regular", size: size))
    }
}

struct CustomFontMediumModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter_18pt-Medium", size: size))
    }
}

struct CustomFontBoldModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Inter_18pt-Bold", size: size))
    }
}
struct CustomFontRobotoBoldModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Roboto-Bold", size: size))
    }
}
struct CustomFontRobotoMediumModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Roboto-Medium", size: size))
    }
}
struct CustomFontRobotoRegularModifier: ViewModifier {
    var size: CGFloat
    func body(content: Content) -> some View {
        content
            .font(.custom("Roboto-Regular", size: size))
    }
}

extension View {
    func customFont(size: CGFloat) -> some View {
        self.modifier(CustomFontModifier(size: size))
    }
    func customFontMedium(size: CGFloat) -> some View {
        self.modifier(CustomFontMediumModifier(size: size))
    }
    func customFontBold(size: CGFloat) -> some View {
        self.modifier(CustomFontBoldModifier(size: size))
    }
    func customFontRobotoBold(size: CGFloat) -> some View {
        self.modifier(CustomFontRobotoBoldModifier(size: size))
    }
    func customFontRobotoRegular(size: CGFloat) -> some View {
        self.modifier(CustomFontRobotoRegularModifier(size: size))
    }
    func customFontRobotoMedium(size: CGFloat) -> some View {
        self.modifier(CustomFontRobotoMediumModifier(size: size))
    }
//    func customFontLocalize(size: CGFloat) -> some View {
//        self.modifier(CustomFontLocalization(size: size))
//    }
//    func customFontMediumLocalize(size: CGFloat) -> some View {
//        self.modifier(CustomFontMediumLocalization(size: size))
//    }
//    func customFontSemiBoldLocalize(size: CGFloat) -> some View {
//        self.modifier(CustomFontSemiblodLocalization(size: size))
//    }
//    func customFontBoldLocalize(size: CGFloat) -> some View {
//        self.modifier(CustomFontBoldLocalization(size: size))
//    }
}


