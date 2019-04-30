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
    
    //MARK: FETCH USER-POST FOR USER
    static func fetchPost(forUser user: User) -> [Post]? {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: "Post")
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]
        var posts = [Post]()
        
        do {
            posts = try PresistentService.context.fetch(fetchRequest) as! [Post]
        } catch let error as NSError {
            print(error)
        }
        
        if posts.count >= 0 {
            return posts
        }
        
        return nil
    }
    
    //MARK: FETCH EXCHANGE
    static func fetchExchange() -> [Exchange]? {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: "Exchange")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "modified", ascending: false)]
        var exchanges = [Exchange]()
        
        do {
            exchanges = try PresistentService.context.fetch(fetchRequest) as! [Exchange]
        } catch let err {
            print(err)
        }
        
        if exchanges.count >= 0 {
            return exchanges
        }
        
        return nil
    }
    
    //MARK: FETCH USERS
    static func fetchUsers() -> [User]? {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: "User")
        var users = [User]()
        
        do {
            users = try PresistentService.context.fetch(fetchRequest) as! [User]
        } catch let err {
            print(err)
        }
        
        if users.count >= 0 {
            return users
        }
        
        return nil
    }
    
    //MARK: FETCH USERS BY ID
    static func fetchUser(byID id: Int32) -> User? {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        var users = [User]()
        
        do {
            users = try PresistentService.context.fetch(fetchRequest) as! [User]
        } catch let err {
            print(err)
        }
        
        if users.count >= 0 {
            return users.first
        }
        
        return nil
    }
    
    //MARK: DELETE ENTITY
    static func deleteRecords(fromEntity entity: String) {
        let fetchRequest = PresistentService.entityFetchRequest(forEntity: entity)
        var records = [AnyObject]()
        
        do {
            records = try PresistentService.context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error)
        }
        
        for obj in records {
            PresistentService.context.delete(obj as! NSManagedObject)
        }
        
        do {
            try PresistentService.context.save()
            print("Deleted!")
        } catch let error as NSError  {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
}
