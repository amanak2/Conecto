//
//  PresistanceService.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import CoreData

class PresistentService {
    
    //MARK: SAVE DATA
    private init() { }
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "society-connect-app-ios")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("SAVED")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: FETCH REQUEST
    static func entityFetchRequest(forEntity entity: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: entity, in: PresistentService.context)
        fetchRequest.entity = entity
        
        return fetchRequest
    }
    
    //MARK: FETCH ALL USER-POST
    static func fetchUserPost() -> [Post]? {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: "Post")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]
        var posts = [Post]()
        
        do {
            posts = try PresistentService.context.fetch(fetchRequest) as! [Post]
        } catch let err {
            print(err)
        }
        
        if posts.count >= 0 {
            return posts
        }
        
        return nil
    }
}
