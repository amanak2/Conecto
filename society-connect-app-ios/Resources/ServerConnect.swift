//
//  BackendService.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class ServerConnect {
    
    let session = URLSession.shared
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum Result<String> {
        case successBlock
        case failureBlock(String)
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .successBlock
        case 401...500: return .failureBlock("Auth Error")
        case 501...599: return .failureBlock("Bad Request")
        case 600: return .failureBlock("Outdated")
        default: return .failureBlock("FAIL")
        }
    }
    
    //MARK: LOGIN REQUESTS
    func fbLogin(url: String, token: String, completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let params: [String: Any] = [
            "accessToken": token
        ]
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .successBlock:
                    guard let data = data else { return }
                    completion(data, nil)
                case .failureBlock(let networkError):
                    completion(data, networkError)
                }
                
            }
            
        }.resume()
    }
    
    func registerReq(url: String, params: [String: Any], completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .successBlock:
                    guard let data = data else { return }
                    completion(data, nil)
                case .failureBlock(let networkError):
                    completion(data, networkError)
                }
                
            }
            
        }.resume()
        
    }
    
    func getRequest(url: String, completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        let authToken = UserUtil.fetchString(forKey: "token")
        let token = "Token \(authToken ?? "")"
        
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .successBlock:
                    guard let data = data else { return }
                    completion(data, nil)
                case .failureBlock(let networkError):
                    completion(nil, networkError)
                }
                
            }
            
        }.resume()
    }
    
    func postRequest(url: String, params: [String: Any], completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        let authToken = UserUtil.fetchString(forKey: "token")
        let token = "Token \(authToken ?? "")"
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .successBlock:
                    guard let data = data else { return }
                    completion(data, nil)
                case .failureBlock(let networkError):
                    completion(nil, networkError)
                }
                
            }
            
        }.resume()
    }
    
    func patchRequest(url: String, params: [String: Any], completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        let authToken = UserUtil.fetchString(forKey: "token")
        let token = "Token \(authToken ?? "")"
        
        request.httpMethod = HTTPMethod.patch.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
        
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .successBlock:
                    guard let data = data else { return }
                    completion(data, nil)
                case .failureBlock(let networkError):
                    completion(nil, networkError)
                }
                
            }
            
        }.resume()
    }

}
