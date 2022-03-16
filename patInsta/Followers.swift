//
//  Followers.swift
//  patInsta
//
//  Created by Reza Kashkoul on 25-Esfand-1400 .
//

import Foundation

struct UserFollowers: Codable {
    let users: [User]
    let next_max_id: String
}


