//
//  ViewModel.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import Foundation
import Combine

// ViewModel for managing state and API calls
@MainActor
class ViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var teleCode: String = "+91"
    @Published var otp: String = ""
    @Published var isLoading: Bool = false
    @Published var notes: [Note] = []
    @Published var likes: [LikeProfile] = []
    @Published var authToken: String = ""
    @Published var errorMessage: String? = nil
    @Published var isPhoneNumberValid: Bool = false
    @Published var isOTPValid: Bool = false
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
        $phoneNumber
            .map { $0.count == 10 }
            .assign(to: &$isPhoneNumberValid)
        
        $otp
            .map { $0.count == 4 }
            .assign(to: &$isOTPValid)
    }
    
    func startCountdown() {
            countdown = 60
            showResendButton = false
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { @MainActor [weak self] _ in
                guard let self = self else { return }
                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    self.timer?.invalidate()
                    self.showResendButton = true
                }
            }
        }
    
    func requestOTP() async {
        guard phoneNumber.count == 10 else {
            self.errorMessage = "Invalid phone number"
            return
        }
        isLoading = true
        do {
            try await NetworkManager.shared.requestOTP(phoneNumber: phoneNumber, teleCode: teleCode)
            self.isLoading = false
            self.errorMessage = nil
            self.startCountdown()
            self.currentScreen = .verifyOTP
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    func verifyOTP() async {
        guard otp.count == 4 else {
            self.errorMessage = "Invalid OTP"
            return
        }
        isLoading = true
        do {
            let token = try await NetworkManager.shared.verifyOTP(phoneNumber: phoneNumber, teleCode: teleCode, otp: otp)
            self.isLoading = false
            self.authToken = token
            await self.getNotes()
        } catch {
            self.isLoading = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    func getNotes() async {
            guard !authToken.isEmpty else {
                self.errorMessage = "No auth token available"
                return
            }
            isLoading = true
            do {
                let response = try await NetworkManager.shared.getNotes(authToken: authToken)
                self.isLoading = false
                self.notes = response.0
                self.likes = response.1
                self.currentScreen = .notes
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
}
