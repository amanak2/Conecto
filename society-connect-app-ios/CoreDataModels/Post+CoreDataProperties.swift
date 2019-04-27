//
//  Post+CoreDataProperties.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var created: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: Int32
    @NSManaged public var likes: Int32
    @NSManaged public var modified: String?
    @NSManaged public var photo1: String?
    @NSManaged public var photo2: String?
    @NSManaged public var photo3: String?
    @NSManaged public var sortOrder: Int32
    @NSManaged public var tags: String?
    @NSManaged public var title: String?
    @NSManaged public var views: Int32
    @NSManaged public var likedByCurrentUser: Bool
    @NSManaged public var society: Society?
    @NSManaged public var user: User?

}
