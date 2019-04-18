//
//  Exchange.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class Exchange: Codable {
    let id: Int
    let user: User
    let society: Society
    let title, description, photo1, photo2, photo3, price: String
    let active, sold_out: Bool
    let views: Int
    let created, modified: String
    
    init(id: Int, user: User, society: Society, title: String, description: String, photo1: String, photo2: String, photo3: String, price: String, active: Bool, sold_out: Bool, views: Int, created: String, modified: String) {
        
        self.id = id
        self.user = user
        self.society = society
        self.title = title
        self.description = description
        self.photo1 = photo1
        self.photo2 = photo2
        self.photo3 = photo3
        self.price = price
        self.active = active
        self.sold_out = sold_out
        self.views = views
        self.created = created
        self.modified = modified
    }
}
