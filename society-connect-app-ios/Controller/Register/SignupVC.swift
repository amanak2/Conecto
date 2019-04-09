//
//  SignupVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class SignupVC: UIViewController, Alertable {

    //MARK: IBOutlets
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var password2TF: UITextField!
    @IBOutlet weak var signupBtn: MainBtn!
    
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Theme.whiteColor
    }
    
    private func registerReq() {
        
        let serverConnect = ServerConnect()
        let parameters: [String: Any] = [
            "username": usernameTF.text ?? "",
            "email": emailTF.text ?? "",
            "password1": passwordTF.text ?? "",
            "password2": password2TF.text ?? ""
        ]
        
        
        serverConnect.registerReq(url: "rest-auth/registration/", params: parameters) { (data, error) in
            
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
        
        if let token = res["key"] as? String {
            UserUtil.saveString(withValue: token, forKey: "token")
            
            UserUtil.saveBool(withValue: true, forKey: "isLoggedIn")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
    //MARK: ACTION BTNS
    @IBAction func signupBtnPressed(_ sender: Any) {
        signupBtn.showLoading()
        registerReq()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                return 
            }
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        navigationController?.pushViewController(controller, animated: true)
    }
}
