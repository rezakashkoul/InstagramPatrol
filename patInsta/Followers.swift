//
//  Followers.swift
//  patInsta
//
//  Created by Reza Kashkoul on 25-Esfand-1400 .
//

import Foundation

struct UserFollowers: Codable {
    let users: [FollowerDetails]
    let next_max_id: String?
}

struct FollowerDetails: Codable {
    let username, full_name: String?
    let pk: Int?
    let profile_pic_url: String?
    let profile_pic_id: String?
}
