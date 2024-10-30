//
//  ContentView.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
//    @StateObject var viewModel = MockViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                switch viewModel.currentScreen {
                    case .phoneNumber:
                        PhoneNumberView(viewModel: viewModel)
                    case .verifyOTP:
                        OTPView(viewModel: viewModel)
                    case .notes:
                        NotesView(viewModel: viewModel)
                    }
            }
//            .padding()
            .preferredColorScheme(.light)
            .navigationTitle("Aisle")
            
            // Loader overlay
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
        }
        .background(Color.white)
    }
}

//#Preview {
//    ContentView()
//}
