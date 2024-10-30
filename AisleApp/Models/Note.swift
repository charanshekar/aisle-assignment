//
//  Note.swift
//  AisleApp
//
//  Created by Charan Shekar on 29/10/24.
//

import Foundation

struct Note: Identifiable {
    let id: UUID = UUID()
    let name: String
    let age: Int
    let imageURL: String
}

struct LikeProfile: Identifiable {
    let id: UUID = UUID()
    let firstName: String
    let avatar: String
}

// Enum for the Picker items
enum TabItem: String, CaseIterable, Identifiable {
    case discover = "Discover"
    case notes = "Notes"
    case matches = "Matches"
    case profile = "Profile"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .discover: return "magnifyingglass"
        case .notes: return "note.text"
        case .matches: return "person.2"
        case .profile: return "person.crop.circle"
        }
    }
}

struct OTPResponse: Decodable {
    let status: Bool
}

struct TokenResponse: Decodable {
    let token: String?
}

struct ResponseBody: Decodable {
    struct InviteProfile: Decodable {
        struct GeneralInformation: Decodable {
            let first_name: String
            let age: Int
        }
        let general_information: GeneralInformation
        let photos: [Photo]
        struct Photo: Decodable {
            let photo: String
            let selected: Bool
        }
    }
    let invites: Invites
    struct Invites: Decodable {
        let profiles: [InviteProfile]
    }
    let likes: Likes
    struct Likes: Decodable {
        let profiles: [LikeInfo]
        struct LikeInfo: Decodable {
            let first_name: String
            let avatar: String
        }
    }
}
