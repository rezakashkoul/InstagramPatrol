//  UserProfile.swift
//  InstagramPatrol
//
//  Created by Reza Kashkoul on 25-Esfand-1400 .
//

import Foundation

struct UserProfile: Codable {
    let graphql: UserProfileDetails
}

struct UserProfileDetails: Codable {
    let user: UserBiography
}

struct UserBiography: Codable {
    let edge_followed_by: UserFollowersCount
}

struct UserFollowersCount: Codable {
    let count: Int
}
