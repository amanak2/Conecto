//
//  BackendService.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import Alamofire

class ServerConnect {
    
    var successBlock: ((_ statusCode: Int, _ response: DataResponse<Any>?) -> Void)?
    var failureBlock: ((_ statusCode: Int, _ error: Error?) -> Void)?
    
    //MARK: Check Internet
    class func isConnected() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    //MARK: FB LOGIN
    func fbLogin(url: String, token: String) {
        
        let headers: HTTPHeaders = [
            "ContentType": "application/json"
        ]
        
        let parameters: Parameters = [
            "accessToken": token
        ]
        
        let urlString = "\(BASE_URL)\(url)"
        let url = URL(string: urlString)
        
        Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .success(_):
                    self.successBlock!((response.response?.statusCode)!, response)
                    break
                case .failure(let error):
                    self.failureBlock!((response.response?.statusCode)!, error)
                    break
                }
        }
    }
    
}
