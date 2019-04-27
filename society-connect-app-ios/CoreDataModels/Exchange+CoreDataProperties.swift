//
//  Exchange+CoreDataProperties.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData


extension Exchange {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exchange> {
        return NSFetchRequest<Exchange>(entityName: "Exchange")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var photo1: String?
    @NSManaged public var photo2: String?
    @NSManaged public var photo3: String?
    @NSManaged public var price: String?
    @NSManaged public var active: Bool
    @NSManaged public var soldOut: Bool
    @NSManaged public var views: Int32
    @NSManaged public var created: String?
    @NSManaged public var modified: String?
    @NSManaged public var user: User?
    @NSManaged public var society: Society?

}
