//
//  Society+CoreDataClass.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Society)
public class Society: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Society", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext, societyModel: SocietyModel) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Society", in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
        self.id = Int32(societyModel.id)
        self.name = societyModel.name
        self.address = societyModel.address
        self.city = societyModel.city
        self.state = societyModel.state
    }
    
}
