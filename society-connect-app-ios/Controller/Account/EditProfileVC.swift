//
//  EditProfileVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 24/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController {

    //MARK: ELEMENTS
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var changeUserImgBtn: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        setupProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setupProfile() {
        
    }
    
    private func setupNavbar() {
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Edit Profile"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
        
        let cancelBtn = UIButton()
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        cancelBtn.addTarget(self, action: #selector(cancelEditProfile), for: .touchUpInside)
        let cancelBtnItem = UIBarButtonItem()
        cancelBtnItem.customView = cancelBtn
        
        let btn = UIButton()
        btn.setTitle("Done", for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(doneEditProfile), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.leftBarButtonItems = [cancelBtnItem]
        self.navigationItem.rightBarButtonItems = [btnItem]
    }
    
    //MARK: ACTION BTNS
    @objc func cancelEditProfile() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneEditProfile() {
        self.navigationController?.popViewController(animated: true)
    }
}
