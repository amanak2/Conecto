//
//  User+CoreDataProperties.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 04/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var dateJoined: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: Int32
    @NSManaged public var lastName: String?
    @NSManaged public var profilePic: String?
    @NSManaged public var username: String?
    @NSManaged public var exchange: NSSet?
    @NSManaged public var post: NSSet?
    @NSManaged public var society: Society?

}

// MARK: Generated accessors for exchange
extension User {

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
extension User {

    @objc(addPostObject:)
    @NSManaged public func addToPost(_ value: Post)

    @objc(removePostObject:)
    @NSManaged public func removeFromPost(_ value: Post)

    @objc(addPost:)
    @NSManaged public func addToPost(_ values: NSSet)

    @objc(removePost:)
    @NSManaged public func removeFromPost(_ values: NSSet)

}
