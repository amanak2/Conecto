//
//  Exchange.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

struct ExchangeModel: Codable {
    let id: Int
    let user: UserModel
    let society: SocietyModel
    let title, desc: String
    let photo1: String?
    let photo2, photo3, price: String
    let active, soldOut: Bool
    let views: Int
    let created, modified: String
    
    enum CodingKeys: String, CodingKey {
        case id, user, society, title
        case desc = "description"
        case photo1, photo2, photo3, price, active
        case soldOut = "sold_out"
        case views, created, modified
    }
}
