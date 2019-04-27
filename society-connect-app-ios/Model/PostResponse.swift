//
//  Response.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 09/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class PostResponse: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [PostModel]
    
    init(count: Int, next: String, previous: String, results: [PostModel]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
