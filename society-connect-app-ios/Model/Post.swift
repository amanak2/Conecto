//
//  Post.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 07/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class Post: Codable {
    let id: Int
    let user: User
    let society: Society
    //let comment: Comment
    let title, description, photo1, photo2: String?
    let photo3: String?
    let likes, views: Int
    let likedByCurrentUser: Bool
    let sortOrder: Int
    let created, modified: String
    let tags: String?
    
    enum CodingKeys: String, CodingKey {
        case id, user, society, /*comment,*/ title, description, photo1, photo2, photo3, likes, views
        case likedByCurrentUser = "liked_by_current_user"
        case sortOrder = "sort_order"
        case created, modified, tags
    }
    
    init(id: Int, user: User, society: Society, /*comment: Comment,*/ title: String, description: String, photo1: String, photo2: String, photo3: String, likes: Int, views: Int, likedByCurrentUser: Bool, sortOrder: Int, created: String, modified: String, tags: String) {
        self.id = id
        self.user = user
        self.society = society
        //self.comment = comment
        self.title = title
        self.description = description
        self.photo1 = photo1
        self.photo2 = photo2
        self.photo3 = photo3
        self.likes = likes
        self.views = views
        self.likedByCurrentUser = likedByCurrentUser
        self.sortOrder = sortOrder
        self.created = created
        self.modified = modified
        self.tags = tags
    }
}
