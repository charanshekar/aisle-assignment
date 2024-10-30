//
//  NetworkManager.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import Foundation

// Network Manager for API calls
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func requestOTP(phoneNumber: String, teleCode: String) async throws {
        let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["number": "\(teleCode)\(phoneNumber)"]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])
        }
        
        let otpResponse = try JSONDecoder().decode(OTPResponse.self, from: data)
        guard otpResponse.status else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: """
                                                          Enter Phone number:
                                                          type '9876543212' to proceed
                                                          """])
        }
    }

    func verifyOTP(phoneNumber: String, teleCode: String, otp: String) async throws -> String {
        let url = URL(string: "https://app.aisle.co/V1/users/verify_otp")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["number": "\(teleCode)\(phoneNumber)", "otp": otp]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        // Perform the network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP response and status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handling non-200 status codes as network errors
        guard httpResponse.statusCode == 200 else {
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Network error: status code \(httpResponse.statusCode)"]
            )
        }
        
        let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
        
        // Check if token is present
        guard let token = tokenResponse.token else {
            throw NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid OTP"]
            )
        }
        
        // Return the token
        return token
    }

    func getNotes(authToken: String) async throws -> ([Note], [LikeProfile]) {
        let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        // Perform the network request using async/await
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP response and status code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Handle non-200 status codes as network errors
        guard httpResponse.statusCode == 200 else {
            throw NSError(
                domain: "",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Network error: status code \(httpResponse.statusCode)"]
            )
        }
        
        // Parse the response payload
        do {
            let decodedResponse = try JSONDecoder().decode(ResponseBody.self, from: data)
            
            let notes = decodedResponse.invites.profiles.compactMap { profile -> Note? in
                guard let selectedPhoto = profile.photos.first(where: { $0.selected }) else {
                    return nil
                }
                return Note(
                    name: profile.general_information.first_name,
                    age: profile.general_information.age,
                    imageURL: selectedPhoto.photo
                )
            }
            
            let likes = decodedResponse.likes.profiles.map { profile -> LikeProfile in
                return LikeProfile(
                    firstName: profile.first_name,
                    avatar: profile.avatar
                )
            }
            
            return (notes, likes)
        } catch {
            throw NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to parse response: \(error.localizedDescription)"]
            )
        }
    }

}
