//
//  User+CoreDataClass.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext, userModel: UserModel) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
        self.username = userModel.username
        self.email = userModel.email
        self.id = Int32(userModel.id)
        //self.society = userModel.society
        self.firstName = userModel.firstName
        self.lastName = userModel.lastName
        self.dateJoined = userModel.dateJoined
        self.profilePic = userModel.profilePic
    }
    
}
