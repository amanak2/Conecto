//
//  BackendService.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import Foundation

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
    
    func getRequest(url: URL, completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        var request = URLRequest(url: url)
        
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

    //MARK: MULTIPART FUNCS
    func generateBoundry() -> String {
        let boundary = "Boundary-\(UUID().uuidString)"
        return boundary
    }
    
    func createDataBody(forParams params: [String: String]?, withMedia media: [Media]?, boundry: String) -> Data? {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let params = params {
            for (key, value) in params {
                body.append("--\(boundry + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundry + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append("\(lineBreak)")
            }
        }
        
        body.append("--\(boundry)--\(lineBreak)")
        
        return body
    }
    
    //MARK: MULTIPART POST REQUEST
    func multipartPostRequest(url: String, method: HTTPMethod, params: [String: String], media: [Media]?, completion: @escaping (_ data: Data?, _ error: String?) -> ()) {
        
        let authToken = UserUtil.fetchString(forKey: "token")
        let token = "Token \(authToken ?? "")"
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        
        request.httpMethod = method.rawValue
        let boundry = generateBoundry()
        
        request.addValue("multipart/form-data; boundary=\(boundry)", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        guard let httpBody = createDataBody(forParams: params, withMedia: media, boundry: boundry) else { return }
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


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
