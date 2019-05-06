//
//  Society+CoreDataProperties.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData


extension Society {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Society> {
        return NSFetchRequest<Society>(entityName: "Society")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var exchange: NSSet?
    @NSManaged public var post: NSSet?
    @NSManaged public var user: NSSet?

}

// MARK: Generated accessors for exchange
extension Society {

    @objc(addExchangeObject:)
    @NSManaged public func addToExchange(_ value: Exchange)

    @objc(removeExchangeObject:)
    @NSManaged public func removeFromExchange(_ value: Exchange)

    @objc(addExchange:)
    @NSManaged public func addToExchange(_ values: NSSet)

    @objc(removeExchange:)
    @NSManaged public func removeFromExchange(_ values: NSSet)

}

// MARK: Generated accessors for post
extension Society {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: Post)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: Post)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}

// MARK: Generated accessors for user
extension Society {

    @objc(addUserObject:)
    @NSManaged public func addToUser(_ value: User)

    @objc(removeUserObject:)
    @NSManaged public func removeFromUser(_ value: User)

    @objc(addUser:)
    @NSManaged public func addToUser(_ values: NSSet)

    @objc(removeUser:)
    @NSManaged public func removeFromUser(_ values: NSSet)

}
