//
//  CreatePostVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 18/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController, UITextViewDelegate, Alertable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: DATA
    var imagePicker = UIImagePickerController()
    let context = PresistentService.context
    
    //MARK: ELEMENTS
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = Theme.lightGrey
        img.layer.cornerRadius = 24
        img.clipsToBounds = true
        return img
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        return lbl
    }()
    
    lazy var postTxt: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.text = "Whats on your mind?"
        tv.font = Theme.largeFont
        tv.textColor = UIColor.lightGray
        tv.delegate = self
        return tv
    }()
    
    let selectedImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        return img
    }()
    
    //MARK VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = UserUtil.fetchInt(forKey: "ME")
        let user = PresistentService.fetchUser(byID: Int32(id!))
        usernameLbl.text = user?.username
        
        setupView()
        setupNavbar()
        setupKeyboard()
    }
    
    private func setupView() {
        view.addSubview(profileImg)
        view.addSubview(usernameLbl)
        view.addSubview(postTxt)
        view.addSubview(selectedImg)
        
        view.addContraintWithFormat(format: "H:|-10-[v0(48)]-8-[v1]-10-|", views: profileImg, usernameLbl)
        view.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: postTxt)
        view.addContraintWithFormat(format: "V:|-8-[v0(48)]-8-[v1]", views: profileImg, postTxt)
        view.addContraintWithFormat(format: "V:|-16-[v0]", views: usernameLbl)
        
        view.addContraintWithFormat(format: "H:|[v0]|", views: selectedImg)
        view.addConstraint(NSLayoutConstraint(item: selectedImg, attribute: .top, relatedBy: .equal, toItem: postTxt, attribute: .bottom, multiplier: 1, constant: 8))
        
        let height = view.frame.width * 4/5
        view.addContraintWithFormat(format: "V:[v0(\(height))]", views: selectedImg)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setupNavbar() {
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Create Post"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
        
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.tintColor = Theme.whiteColor
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(cancelCreatePost), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.leftBarButtonItems = [btnItem]
    }
    
    private func setupKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
        let imgBtn: UIBarButtonItem = UIBarButtonItem(title: "Add Photo", style: .done, target: self, action: #selector(handleImgUpload))
        
        let items = [imgBtn, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.postTxt.inputAccessoryView = doneToolbar
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Whats on your mind?" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    //MARK: API
    private func createPost() {
        
        let serverConnect = ServerConnect()
        let parameters: [String: String] = [
            "title": "post",
            "description": postTxt.text ?? "",
            "photo2": "nil",
            "photo3": "nil"
        ]
        
        var media = [Media]()
        if let img = selectedImg.image {
            let photo1 = Media(withImg: img, forKey: "photo1")
            media.append(photo1!)
        } else {
            media.removeAll()
        }
        
        serverConnect.multipartPostRequest(url: "api/v1/user-post/", method: .post, params: parameters, media: media) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let _ = try JSONDecoder().decode(PostModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch let err{
                    print(err)
                }
            }
        }
        
    }
    
    //MARK: ACTIONS BTNS
    @objc func cancelCreatePost() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDone() {
        createPost()
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
            self.selectedImg.image = pickedImg
            self.dismiss(animated: true, completion: nil)
        }
    }
}
