//
//  Exchange+CoreDataClass.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Exchange)
public class Exchange: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Exchange", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext, exchangeModel: ExchangeModel) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Exchange", in: context)!
        self.init(entity: entityDescription, insertInto: context)
        
        self.id = Int32(exchangeModel.id)
//        self.user = exchangeModel.
//        self.society = exchangeModel.
        self.title = exchangeModel.title
        self.desc = exchangeModel.desc
        self.photo1 = exchangeModel.photo1
        self.photo2 = exchangeModel.photo2
        self.photo3 = exchangeModel.photo3
        self.price = exchangeModel.price
        self.active = exchangeModel.active
        self.soldOut = exchangeModel.soldOut
        self.views = Int32(exchangeModel.views)
        self.created = exchangeModel.created
        self.modified = exchangeModel.modified
    }
}
