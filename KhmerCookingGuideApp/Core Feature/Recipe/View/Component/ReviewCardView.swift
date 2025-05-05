//
//  ReviewCardView.swift
//  KhmerCookingGuideApp
//
//  Created by Sok Reaksa on 14/3/25.
//

import Kingfisher
import SwiftUI

struct ReviewCardView: View {
    var userProfile: String
    var userName: String
    var reviewText: String
    var rating: Int
    var isHasThreeDots: Bool
    @State var isShowPopover: Bool = false
    var onEditTapped: () -> Void // Callback when "Edit" is tapped
    var onDeleteTapped: () -> Void

    var body: some View {
        VStack {
            let imageUrl = "\(API.baseURL)/fileView/"

            VStack(alignment: .leading, spacing: 8) {
                // Review Title
                HStack {
                    if userProfile == "default.jpg" {
                        Image("defaultPFMale")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    } else {
                        KFImage(URL(string: imageUrl + "\(userProfile)"))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                    Text(userName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }
                // Star Rating Display
                HStack(spacing: 2) {
                    ForEach(0 ..< 5, id: \.self) { index in
                        Image(systemName: index < rating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.yellow)
                    }
                }
                // Review Text
                Text(reviewText)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.darkGray))
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(alignment: .topTrailing) {
                if isHasThreeDots {
                    Button {
                        isShowPopover = true
                    } label: {
                        Image("black-dot")
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    .padding()
                    .popover(isPresented: $isShowPopover) {
                        PopupView(showPopup: $isShowPopover, onEditTapped: {
                            onEditTapped()
                            isShowPopover = false

                        }, onDeleteTapped: {
                            onDeleteTapped()
                            print("fasdkjfv", reviewText, rating, userName)
                            isShowPopover = false
                        })
                        .presentationCompactAdaptation(.none)
                    }
                }
            }
        }
        .onChange(of: isHasThreeDots) {
            print("ach", reviewText, rating, userName, isHasThreeDots)
        }
        .onAppear {
            print("fasdkjfv", reviewText, rating, userName)
        }
    }
}
