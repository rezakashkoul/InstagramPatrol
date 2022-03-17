//  User.swift
//  InstagramPatrol
//
//  Created by Reza Kashkoul on 23-Esfand-1400 .
//

import Foundation

struct UserQuery: Codable {
    var users: [UserElement]
    let rank_token: String
    let status: String
}

struct UserElement: Codable {
    var user: User
}

struct User: Codable {
    let pk, username, fullName: String
    let profilePicURL: String
    let profilePicID: String?
    var userFollowerCount: Int? // khodam ezafeash kardam


    enum CodingKeys: String, CodingKey {
        case pk, username
        case fullName = "full_name"
        case profilePicURL = "profile_pic_url"
        case profilePicID = "profile_pic_id"
    }
}
