//
//  ExchangeResponse.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

class ExchangeResponse: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [Exchange]
    
    init(count: Int, next: String, previous: String, results: [Exchange]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
