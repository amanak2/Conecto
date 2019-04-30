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
    
    //MARK: SYNC USER-POST
    func fetchUserPost(completion: @escaping (_ post: [Post]?, _ error: String?) -> ()) {
        var ps: [Post] = []
        let url: URL!
        
        if UserUtil.fetchString(forKey: "postNextURL") != nil {
            url = URL(string: UserUtil.fetchString(forKey: "postNextURL")!)
        } else {
            let urlString = "\(BASE_URL)api/v1/user-post/?show_society=true&limit=10"
            url = URL(string: urlString)
        }
        
        ServerConnect().getRequest(url: url!) { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PostResponse.self, from: data)
                    
                    if let next = response.next {
                        UserUtil.saveString(withValue: next, forKey: "postNextURL")
                    } else {
                        UserUtil.removeObj(forKey: "postNextURL")
                    }
                    
                    let posts = response.results
                    posts.forEach({ (post) in
                        let user = User(context: self.context, userModel: post.user)
                        let society = Society(context: self.context, societyModel: post.society)
                        
                        user.society = society
                        
                        let p = Post(context: self.context, postModel: post)
                        p.user = user
                        p.society = society
                        
                        ps.append(p)
                    })
                    
                    PresistentService.saveContext()
                    completion(ps,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
        }
    }
    
    //MARK: SYNC POSTS FOR USER
    func fetchPostForUser(completion: @escaping (_ post: [Post]?, _ error: String?) -> ()) {
        var ps: [Post] = []
        let url: URL!
        
        if UserUtil.fetchString(forKey: "postForUserNextURL") != nil {
            url = URL(string: UserUtil.fetchString(forKey: "postForUserNextURL")!)
        } else {
            let urlString = "\(BASE_URL)api/v1/user-post/?limit=10"
            url = URL(string: urlString)
        }
        
        ServerConnect().getRequest(url: url!) { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PostResponse.self, from: data)
                    
                    if let next = response.next {
                        UserUtil.saveString(withValue: next, forKey: "postForUserNextURL")
                    } else {
                        UserUtil.removeObj(forKey: "postForUserNextURL")
                    }
                    
                    let posts = response.results
                    posts.forEach({ (post) in
                        let user = User(context: self.context, userModel: post.user)
                        let society = Society(context: self.context, societyModel: post.society)
                        
                        let p = Post(context: self.context, postModel: post)
                        p.user = user
                        p.society = society
                        
                        ps.append(p)
                    })
                    
                    PresistentService.saveContext()
                    completion(ps,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
        }
    }
    
    //MARK: SYNC EXCHANGE
    func fetchExchange(completion: @escaping (_ exchange: [Exchange]?, _ error: String?) -> ()) {
        var es: [Exchange] = []
        let url: URL!
        
        if UserUtil.fetchString(forKey: "exchangeNextURL") != nil {
            url = URL(string: UserUtil.fetchString(forKey: "exchangeNextURL")!)
        } else {
            let urlString = "\(BASE_URL)api/v1/exchange-items/?show_society=true&limit=10"
            url = URL(string: urlString)
        }
        
        ServerConnect().getRequest(url: url!) { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(ExchangeResponse.self, from: data)
                    
                    if let next = response.next {
                        UserUtil.saveString(withValue: next, forKey: "exchangeNextURL")
                    } else {
                        UserUtil.removeObj(forKey: "exchangeNextURL")
                    }
                    
                    let exchanges = response.results
                    exchanges.forEach({ (exchange) in
                        let user = User(context: self.context, userModel: exchange.user)
                        let society = Society(context: self.context, societyModel: exchange.society)
                        
                        let e = Exchange(context: self.context, exchangeModel: exchange)
                        e.user = user
                        e.society = society
                        
                        es.append(e)
                    })
                    
                    PresistentService.saveContext()
                    completion(es,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
        }
    }
    
    //MARK: SYNC USERS
    func fetchUsers(completion: @escaping (_ user: [User]?, _ error: String?) -> ()) {
        var us: [User] = []
        let url: URL!
        
        if UserUtil.fetchString(forKey: "userNextURL") != nil {
            url = URL(string: UserUtil.fetchString(forKey: "userNextURL")!)
        } else {
            let urlString = "\(BASE_URL)api/v1/users/?show_society=true&limit=10"
            url = URL(string: urlString)
        }
        
        ServerConnect().getRequest(url: url!) { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
                    
                    if let next = response.next {
                        UserUtil.saveString(withValue: next, forKey: "userNextURL")
                    } else {
                        UserUtil.removeObj(forKey: "userNextURL")
                    }
                    
                    let users = response.results
                    users.forEach({ (user) in
                        let society = Society(context: self.context, societyModel: user.society!)
                        
                        let u = User(context: self.context, userModel: user)
                        u.society = society
                        
                        us.append(u)
                    })
                    
                    PresistentService.saveContext()
                    completion(us,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
        }
    }
    
    //MARK: SYNC SELF
    func fetchSelf(completion: @escaping (_ user: User?, _ error: String?) -> ()) {
        var us: User?
        
        let urlString = "\(BASE_URL)api/v1/users/"
        let url = URL(string: urlString)
        
        ServerConnect().getRequest(url: url!) { (data, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(UserResponse.self, from: data)
                    
                    let users = response.results
                    users.forEach({ (user) in
                        let society = Society(context: self.context, societyModel: user.society!)
                        
                        let u = User(context: self.context, userModel: user)
                        u.society = society
                        
                        us = u
                    })
                    
                    PresistentService.saveContext()
                    completion(us,nil)
                    
                } catch let err {
                    completion(nil, err.localizedDescription)
                }
            }
        }
    }
}
