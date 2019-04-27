//
//  Synchronizer.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 25/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import Foundation
import CoreData

class Synchronizer {
    
    //MARK: CORE DATA
    let context = PresistentService.context
    
    //MARK: FUNCTIONS
    func syncUserPost(completion: @escaping (_ post: [Post]?, _ error: String?) -> ()) {
        var ps: [Post] = []
        
        ServerConnect().getRequest(url: "api/v1/user-post/?show_society=true") { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PostResponse.self, from: data)
                    
                    if let next = response.next {
                        UserUtil.saveString(withValue: next, forKey: "postNextURL")
                    } else {
                        UserUtil.saveString(withValue: "", forKey: "postNextURL")
                    }
                    
                    if let previous = response.previous {
                        UserUtil.saveString(withValue: previous, forKey: "postPreviousURL")
                    } else {
                        UserUtil.saveString(withValue: "", forKey: "postPreviousURL")
                    }
                    
                    let posts = response.results
                    posts.forEach({ (post) in
                        let user = User(context: self.context, userModel: post.user)
                        let society = Society(context: self.context, societyModel: post.society)
                        
                        let p = Post(context: self.context, postModel: post)
                        p.user = user
                        p.society = society
                    })
                    
                    PresistentService.saveContext()
                    ps = PresistentService.fetchUserPost()!
                    completion(ps,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
            
        }
        
    }
    
}
