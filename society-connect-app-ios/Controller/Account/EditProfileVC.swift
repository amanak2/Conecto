//
//  EditProfileVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 24/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift

class EditProfileVC: UIViewController, Alertable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: VARIABLE
    var user: User?
    var imagePicker = UIImagePickerController()
    
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
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        setupNavbar()
        setupProfile()
        
        changeUserImgBtn.addTarget(self, action: #selector(handleImgUpload), for: .touchUpInside)
        userImg.layer.cornerRadius = userImg.frame.height / 2
        userImg.clipsToBounds = true
        userImg.contentMode = .scaleAspectFill
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setupProfile() {
        usernameTF.text = user?.username
        emailTF.text = user?.email
        firstNameTF.text = user?.firstName
        lastNameTF.text = user?.lastName
        
        if let img = user?.profilePic {
            userImg.sd_setImage(with: URL(string: img), completed: nil)
        }
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
    
    //MARK: API FUNC
    private func updateProfile() {
        
        let serverConnect = ServerConnect()
        let id = user?.id ?? 0
        
        let parameters: [String: String] = [
            "username": usernameTF.text ?? "",
            "email": emailTF.text ?? "",
            "first_name": firstNameTF.text ?? "",
            "last_name": lastNameTF.text ?? "",
        ]
        
        var media = [Media]()
        if let img = userImg.image {
            let profile_pic = Media(withImg: img, forKey: "profile_pic")
            media.append(profile_pic!)
        } else {
            media.removeAll()
        }
        
        serverConnect.multipartPostRequest(url: "api/v1/users/\(id)/", method: .patch, params: parameters, media: media) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let _ = data {
                
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    //MARK: ACTION BTNS
    @objc func cancelEditProfile() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneEditProfile() {
        self.updateProfile()
    }
    
    //MARK: SELECT IMAGE
    @objc func handleImgUpload() {
        let alertController = UIAlertController()
        imagePicker.delegate = self
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert("Camera", "Camera is not available on this device or accesibility has been revoked!")
            }
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert("Photo Library", "Photo Library is not available on this device or accesibility has been revoked!")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.userImg.image = pickedImg
            self.dismiss(animated: true, completion: nil)
        }
    }
}
