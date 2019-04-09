//
//  User.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 07/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class User: Codable {
    let username, email: String
    let id: Int
    let society: Society
    let firstName, lastName: String?
    let dateJoined: String
    let profilePic: String?
    
    enum CodingKeys: String, CodingKey {
        case username, email, id, society
        case firstName = "first_name"
        case lastName = "last_name"
        case dateJoined = "date_joined"
        case profilePic = "profile_pic"
    }
    
    init(username: String, email: String, id: Int, society: Society, firstName: String, lastName: String, dateJoined: String, profilePic: String) {
        self.username = username
        self.email = email
        self.id = id
        self.society = society
        self.firstName = firstName
        self.lastName = lastName
        self.dateJoined = dateJoined
        self.profilePic = profilePic
    }
}
