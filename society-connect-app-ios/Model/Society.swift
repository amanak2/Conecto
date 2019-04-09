//
//  Society.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 07/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class Society: Codable {
    let id: Int
    let name, address, city, state: String
    
    init(id: Int, name: String, address: String, city: String, state: String) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
    }
}
