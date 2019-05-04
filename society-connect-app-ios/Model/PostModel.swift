//
//  Post.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 07/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

struct PostModel: Codable {
    let id: Int
    let user: UserModel
    let society: SocietyModel
    //let comment: CommentModel
    let title, photo1, photo2: String?
    let desc: String?
    let photo3: String?
    let likes, views: Int
    let likedByCurrentUser: Bool
    let sortOrder: Int
    let created, modified: String
    let tags: String?
    
    enum CodingKeys: String, CodingKey {
        case id, user, society, /*comment,*/ title, photo1, photo2, photo3, likes, views
        case likedByCurrentUser = "liked_by_current_user"
        case sortOrder = "sort_order"
        case desc = "description"
        case created, modified, tags
    }
}
