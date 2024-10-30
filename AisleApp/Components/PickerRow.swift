//
//  PickerRow.swift
//  AisleApp
//
//  Created by Charan Shekar on 30/10/24.
//

import SwiftUI

struct PickerRow: View {
    @Binding var selection: TabItem
    
    var body: some View {
        VStack {
            Divider()
                .background(Color.gray)
            HStack(alignment: .center, spacing: 10) {
                ForEach(TabItem.allCases) { item in
                    Button(action: {
                        selection = item
                    }) {
                        VStack(spacing: 0) {
                            Image(systemName: item.iconName)
                                .font(.title2)
                                .frame(width: 20, height: 20)
                                .padding(5)
                                .cornerRadius(2)
                                .foregroundColor(selection == item ? .blue : .primary)
                            Text(item.rawValue)
                                .foregroundColor(selection == item ? .blue : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .padding(.horizontal)
        }
    }
}

#Preview {
    PickerRow(selection: .constant(.notes))
}
