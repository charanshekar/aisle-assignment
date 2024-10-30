//
//  ProfileColumn.swift
//  AisleApp
//
//  Created by Charan Shekar on 30/10/24.
//

import SwiftUI

struct ProfileColumn: View {
    let imageURL: String
    let name: String
    let age: Int
    let subtitle: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                    .cornerRadius(8)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(contentMode: .fit)
            }

            // Overlay Texts
            VStack(alignment: .leading, spacing: 4) {
                Text("\(name), \(age)")
                    .font(.title3)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .font(.system(size: 30))
            .foregroundColor(.white)
            .padding([.leading, .bottom], 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .some(300))
    }
}

#Preview {
    ProfileColumn(imageURL: "https://testimages.aisle.co/f39552690128813a6e893b4f4cd725fc729869938.png", name: "Rakesh", age: 26, subtitle: "Hiejfejrnf rjf")
}
