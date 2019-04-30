//
//  Media.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 30/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

struct Media {
    var key: String
    var filename: String
    var data: Data
    var mimeType: String
    
    init?(withImg Img: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "\(arc4random()).jpeg"
        
        guard let data = Img.jpegData(compressionQuality: 0.7) else { return nil }
        self.data = data
    }
}
