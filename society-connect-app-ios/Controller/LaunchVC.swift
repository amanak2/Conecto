//
//  ViewController.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Alamofire

class LaunchVC: UIViewController, Alertable {
    
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbBtn.backgroundColor = Theme.fbBtnColor
        signupBtn.backgroundColor = Theme.tintColor
        loginBtn.backgroundColor = Theme.tintColor
    }

    private func fbLoginFromAPI(token: String) {
        
        let serverConnect = ServerConnect()
        
        serverConnect.successBlock = {(statusCode: Int , response: DataResponse<Any>?) in
            if response != nil {
                if let responseDict = response!.result.value as? [String: Any] {
                    
                    if let authToken = responseDict["auth_token"] as? String {
                        UserUtil.saveString(withValue: authToken, forKey: "authToken")
                    }
                    
                    if let new_user = responseDict["new_user"] as? Bool {
                        if new_user == false {
                            // go to home page
                        } else if new_user == true {
                            // go to society select
                        }
                    }
                }
            }
        }
        
        serverConnect.failureBlock = {(statudCode: Int, error: Error?) in
            print("FAIL STATUS: ", statudCode)
            
        }
        
        serverConnect.fbLogin(url: "facebook/", token: token)
        
    }
    
    
    //MARK: ACTION BTNs
    @IBAction func fbBtnPressed(_ sender: Any) {
        
        if ServerConnect.isConnected() {
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (loginResult) in
                switch loginResult {
                case .cancelled:
                    print("FB CANCELED")
                case .failed(let error):
                    print(error)
                case .success( _, _, let token):
                    self.fbLoginFromAPI(token: token.authenticationToken)
                }
            }
        } else {
            showAlert("No Internet Connection", "Please check if you are connected to the internet and try again.")
        }
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
    }
}

