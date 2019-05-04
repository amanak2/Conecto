//
//  Protocals.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 24/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation

protocol CellBtnPress: class {
    func btnPressed()
}

protocol FeedActionBtns: class {
    func commentBtnPressed(forPost postID: Int32)
    func likeBtnPressed(forPost postID: Int32)
}
