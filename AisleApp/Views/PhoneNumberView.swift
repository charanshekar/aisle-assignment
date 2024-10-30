//
//  PhoneNumberView.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import SwiftUI

struct PhoneNumberView: View {
    @ObservedObject var viewModel: ViewModel
//    @State var viewModel = MockViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Get OTP")
                .font(.system(size: 25))
                .padding(.top, 20) // Padding to align closer to the top of the screen
                .padding(.horizontal)
            
            Text("""
                Enter Your 
                Phone Number
                """)
                .font(.system(size: 40))
                .fontWeight(.black)
                .padding(.horizontal)

            HStack(spacing: 10) {
                           TextField("+91", text: $viewModel.teleCode)
                               .keyboardType(.numberPad)
                               .padding(10)
                               .frame(width: 90)
                               .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(Color.gray, lineWidth: 1)
                                   )
                               .font(.largeTitle)
                               .fontWeight(.bold)
                               .multilineTextAlignment(.center)
                               .onChange(of: viewModel.teleCode) {
                                   oldValue, newValue in
                                       if !newValue.hasPrefix("+") {
                                           viewModel.teleCode = "+"
                                    }
                               }
                           
                           TextField("Enter Phone Number", text: $viewModel.phoneNumber)
                               .keyboardType(.numberPad)
                               .padding(10)
                               .overlay(
                                       RoundedRectangle(cornerRadius: 8)
                                           .stroke(Color.gray, lineWidth: 1)
                                )
                               .font(.largeTitle)
                               .fontWeight(.bold)
                               .onChange(of: viewModel.phoneNumber) { oldValue, newValue in
                                   if newValue.count > 10 {
                                       viewModel.phoneNumber = String(newValue.prefix(10))
                                   }
                               }
                       }
                       .padding(.horizontal)
            
            Button(action: {
                Task { @MainActor in
                        await viewModel.requestOTP()
                    }
            }) {
                Text("Continue")
                    .padding()
                    .fontWeight(.bold)
                    .background(viewModel.isPhoneNumberValid ? Color.yellow : Color.gray)
                    .foregroundColor(.black)
                    .cornerRadius(25)
            }
            .padding(.horizontal)
            .disabled(!viewModel.isPhoneNumberValid || viewModel.isLoading)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Spacer() // Pushes the content to the top
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Matching Figma width and height
        .background(Color.white) // Set background if needed
        .padding(.top, 50)
    }
}

//#Preview {
//    PhoneNumberView()
//}
