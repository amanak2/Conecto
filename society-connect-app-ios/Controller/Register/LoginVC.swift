//
//  LoginVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, Alertable {

    //MARK: IBOutlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: MainBtn!
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.whiteColor
        
        passwordTF.isSecureTextEntry = true
    }
    
    //MARK: API REQUESTS
    private func loginReq() {
        
        let serverConnect = ServerConnect()
        let parameters: [String: Any] = [
            "username": usernameTF.text ?? "",
            "password": passwordTF.text ?? ""
        ]
        
        serverConnect.registerReq(url: "rest-auth/login/", params: parameters) { (data, error) in
            
            if let error = error {
                print(error)
//                self.showAlert("Incorrect Email/Password", "Check and re-enter Email or Password")
//                self.loginBtn.hideLoading()
            }
            
            if let data = data {
                do {
                    let res = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    DispatchQueue.main.async {
                        self.performOnDateFrom(res: res!)
                    }
                } catch {
                    print(error)
                }
            }
            
        }
    
    }
    
    private func performOnDateFrom(res: [String: Any]) {
        if let token = res["key"] as? String {
            UserUtil.saveString(withValue: token, forKey: "token")
            
            UserUtil.saveBool(withValue: true, forKey: "isLoggedIn")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    //MARK: ACTION BTNS
    @IBAction func loginBtnPressed(_ sender: Any) {
        //loginBtn.showLoading()
        loginReq()
    }
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SignupVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return 
            } 
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SignupVC")
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
