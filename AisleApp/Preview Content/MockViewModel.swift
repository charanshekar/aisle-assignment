//
//  MockViewModel.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import Foundation
import Combine

// Mock ViewModel for previews
class MockViewModel: ObservableObject {
    @Published var phoneNumber: String = "9876543212"
    @Published var teleCode: String = "+91"
    @Published var otp: String = "1234"
    @Published var isLoading: Bool = false
    @Published var notes: [Note] = []
    @Published var likes: [LikeProfile] = []
    @Published var authToken: String = "32c7794d2e6a1f7316ef35aa1eb34541"
    @Published var errorMessage: String? = nil
    @Published var isPhoneNumberValid: Bool = true
    @Published var isOTPValid: Bool = true
    @Published var countdown: Int = 60
    @Published var showResendButton: Bool = false
    @Published var currentScreen: Screen = .phoneNumber
    
    enum Screen {
        case phoneNumber
        case verifyOTP
        case notes
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?

    init() {
        // Set up validation publishers
        $phoneNumber
            .map { $0.count == 10 }
            .assign(to: &$isPhoneNumberValid)
        
        $otp
            .map { $0.count == 4 }
            .assign(to: &$isOTPValid)
        
        // Load mock notes data
        loadMockNotes()
    }
    
    func startCountdown() {
        countdown = 60
        showResendButton = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if self.countdown > 0 {
                self.countdown -= 1
            } else {
                self.showResendButton = true
                timer.invalidate()
            }
        }
    }

    func requestOTP() {
        // Simulate a network delay and success response
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.errorMessage = nil
            self.startCountdown()
            self.currentScreen = .verifyOTP
            // OTP requested successfully
        }
    }

    func verifyOTP() {
        // Simulate a network delay and success response
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.authToken = "mock_auth_token"
            self.errorMessage = nil
            // OTP verified successfully
            self.getNotes()
        }
    }

    func getNotes() {
        // Simulate a network delay and success response
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            self.errorMessage = nil
            self.currentScreen = .notes
            // Notes are already loaded in init
        }
    }

    private func loadMockNotes() {
        // Initialize the notes array with mock data
        self.notes = [
            Note(
                name: "Mayank",
                age: 29,
                imageURL: "https://testimages.aisle.co/f39552690128813a6e893b4f4cd725fc729869938.png"
            ),
            Note(
                name: "Ajith",
                age: 32,
                imageURL: "https://testimages.aisle.co/dd510d5260eeebcdc7d7fc752c598c39728894004.png"
            ),
            Note(
                name: "Ishant",
                age: 30,
                imageURL: "https://testimages.aisle.co/58b125e52d319c0390fc2d68b7da2ba6729804903.png"
            )
            // Add more mock notes as needed
        ]
    }
}
