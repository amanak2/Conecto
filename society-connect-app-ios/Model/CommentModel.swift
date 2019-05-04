//
//  CommentModel.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 04/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

struct CommentModel: Codable {
    let id: Int
    let user: UserModel
    let comment, created, modified: String
    let post: Int
}
