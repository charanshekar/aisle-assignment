//
//  OTPView.swift
//  AisleApp
//
//  Created by Charan Shekar on 30/10/24.
//

import SwiftUI


struct OTPView: View {
    @ObservedObject var viewModel: ViewModel
//    @State var viewModel = MockViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack() {
                Text("\(viewModel.teleCode) \(viewModel.phoneNumber)")
                    .font(.headline)
                    .foregroundColor(.black)

                Button(action: {
                    // Action to go back to PhoneNumberView
                    viewModel.otp = ""
                    viewModel.currentScreen = .phoneNumber
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal)
            
            Text("""
                Enter The
                OTP
                """)
                .font(.system(size: 40))
                .fontWeight(.black)
                .padding(.horizontal)

            TextField("Enter OTP", text: $viewModel.otp)
                .keyboardType(.numberPad)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
                .onChange(of: viewModel.otp) { oldValue, newValue in
                    if newValue.count > 4 {
                        viewModel.otp = String(newValue.prefix(4))
                    }
                }
            
            HStack(spacing: 10) {
                Button(action: {
                    Task { @MainActor in
                        await viewModel.verifyOTP()
                    }
                }) {
                    Text("Continue")
                        .padding()
                        .fontWeight(.bold)
                        .background(viewModel.isOTPValid ? Color.yellow : Color.gray)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                }
                .disabled(!viewModel.isOTPValid || viewModel.isLoading)
                
                Text(String(format: "%02d:%02d", viewModel.countdown / 60, viewModel.countdown % 60))
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            if viewModel.showResendButton {
                Button(action: {
                    Task { @MainActor in
                        await viewModel.requestOTP()
                        }
                }) {
                    Text("Resend OTP")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                        .padding(.horizontal)
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Spacer() // Pushes the content to the top
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Matching Figma width and height
        .background(Color.white) // Set background if needed
        .padding(.top, 62)
    }
}

//#Preview {
//    OTPView()
//}
