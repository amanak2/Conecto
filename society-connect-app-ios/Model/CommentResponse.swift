//
//  CommentResponse.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 04/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class CommentResponse: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [CommentModel]
    
    init(count: Int, next: String, previous: String, results: [CommentModel]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
