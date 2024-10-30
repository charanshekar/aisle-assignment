//
//  BlurredProfileColumn.swift
//  AisleApp
//
//  Created by Charan Shekar on 30/10/24.
//

import SwiftUI

struct BlurredProfileColumn: View {
    let name: String
    let imageURL: String
    let fontSize: CGFloat = 20
    let blur: CGFloat = 6.0
    
    var body: some View {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image.resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                        .cornerRadius(8)
                        .blur(radius: blur)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fit)
                }
                Text(name)
                    .font(.system(size: fontSize))
                    .foregroundColor(.white)
                    .padding([.leading, .bottom], 8)
            }
        }
}

#Preview {
    BlurredProfileColumn(name: "Ayna", imageURL: "https://testimages.aisle.co/f39552690128813a6e893b4f4cd725fc729869938.png")
}
