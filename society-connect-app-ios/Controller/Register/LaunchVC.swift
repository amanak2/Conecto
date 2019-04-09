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

class LaunchVC: UIViewController, Alertable {
    
    //MARK: IBOutlets
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbBtn.backgroundColor = Theme.fbBtnColor
    }

    //MARK: API REQUESTS
    private func fbLoginFromAPI(token: String) {
        
        let serverConnect = ServerConnect()
        
        serverConnect.fbLogin(url: "facebook/", token: token) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
                        self.performOnDataFrom(res: res!)
                    }
                } catch {
                    print(error)
                }
            }
        }
        
    }
    
    private func performOnDataFrom(res: [String: Any]) {
        if let authToken = res["auth_token"] as? String {
            UserUtil.saveString(withValue: authToken, forKey: "authToken")
        }
        
        if let new_user = res["new_user"] as? Bool {
            if new_user == false {
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let controller = storyboard.instantiateViewController(withIdentifier: "")
//                            self.navigationController?.pushViewController(controller, animated: true)
                
            } else if new_user == true {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
        }
    }
        
    
    
    //MARK: ACTION BTNs
    @IBAction func fbBtnPressed(_ sender: Any) {
        
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
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignupVC")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        navigationController?.pushViewController(controller, animated: true)
    }
}

