//
//  AccountVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    //MARK: VIEWCONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        getUser()
    }
    
    private func getUser() {
        let serverConnect = ServerConnect()
        
        serverConnect.getRequest(url: "api/v1/users/") { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func setupNavbar() {
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLbl.textColor = UIColor.white
        titleLbl.text = "username"
        titleLbl.font = Theme.largeFont
        navigationItem.titleView = titleLbl
    }

}
