//
//  Post+CoreDataClass.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Post", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext, postModel: PostModel) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Post", in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
        self.id = Int32(postModel.id)
        //self.user = postModel.user
        //self.society = postModel.society
        //self.comment = postModel.comment
        self.title = postModel.title
        self.desc = postModel.desc
        self.photo1 = postModel.photo1
        self.photo2 = postModel.photo2
        self.photo3 = postModel.photo3
        self.likes = Int32(postModel.likes)
        self.views = Int32(postModel.views)
        self.likedByCurrentUser = postModel.likedByCurrentUser
        self.sortOrder = Int32(postModel.sortOrder)
        self.created = postModel.created
        self.modified = postModel.modified
        self.tags = postModel.tags
        
    }
}
