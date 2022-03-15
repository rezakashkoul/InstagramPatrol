//  User.swift
//  patInsta
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import Foundation

struct UserQuery: Codable {
    let users: [UserElement]
    let rank_token: String
    let status: String
}

struct UserElement: Codable {
    let user: User
}

struct User: Codable {
    let pk, username, fullName: String
    let profilePicURL: String
    let profilePicID: String?

    enum CodingKeys: String, CodingKey {
        case pk, username
        case fullName = "full_name"
        case profilePicURL = "profile_pic_url"
        case profilePicID = "profile_pic_id"
    }
}
