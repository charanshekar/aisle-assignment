//
//  NotesView.swift
//  AisleApp
//
//  Created by Charan Shekar on 30/10/24.
//

import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: ViewModel
//    @State var viewModel = MockViewModel()
    
    var body: some View {
    
        VStack(alignment: .center, spacing: 8) {
                    VStack {
                        Text("Notes")
                            .font(.system(size: 28))
                            .fontWeight(.black)
                            .padding(.top, 35)
                        
                        Text("Personal messages to you")
                            .font(.subheadline)
                    }
                
                    VStack {
                        ProfileColumn(imageURL: viewModel.notes[0].imageURL, name: viewModel.notes[0].name, age: viewModel.notes[0].age, subtitle: "Tap to review 50+ Notes")
                    }
                
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Interested In You")
                                .font(.headline)
                                
                            Text("Premium members can view all their likes at once")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Button(action: {
                            // Action to upgrade
                        }) {
                            Text("Upgrade")
                                .fontWeight(.bold)
                                .padding(10)
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }

                    HStack(spacing: 0) {
                        BlurredProfileColumn(name: viewModel.likes[0].firstName, imageURL: viewModel.likes[0].avatar)
                            .frame(maxWidth: .infinity)
                        Spacer()
                        BlurredProfileColumn(name: viewModel.likes[1].firstName, imageURL:viewModel.likes[1].avatar)
                            .frame(maxWidth: .infinity)
                    }
                                
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Matching Figma width and height
            .background(Color.white) // Set background if needed
            .padding(5)
            .padding(.horizontal)
        
            PickerRow(selection: .constant(.notes))
            .padding(.bottom, 20)
        
        }
}

//#Preview {
//    NotesView()
//}
