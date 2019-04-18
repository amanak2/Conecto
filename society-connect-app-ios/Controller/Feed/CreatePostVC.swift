//
//  CreatePostVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 18/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class CreatePostVC: UIViewController, UITextViewDelegate, Alertable {
    
    //MARK: DATA
    var post: Post?
    
    //MARK: ELEMENTS
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.blue
        img.layer.cornerRadius = 24
        img.clipsToBounds = true
        return img
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.text = "username"
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
    
    //MARK VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavbar()
        setupKeyboard()
    }
    
    private func setupView() {
        view.addSubview(profileImg)
        view.addSubview(usernameLbl)
        view.addSubview(postTxt)
        
        view.addContraintWithFormat(format: "H:|-10-[v0(48)]-8-[v1]-10-|", views: profileImg, usernameLbl)
        view.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: postTxt)
        view.addContraintWithFormat(format: "V:|-8-[v0(48)]-8-[v1]", views: profileImg, postTxt)
        view.addContraintWithFormat(format: "V:|-16-[v0]", views: usernameLbl)
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
        titleLbl.font = Theme.largeFont
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
        let imgBtn: UIBarButtonItem = UIBarButtonItem(title: "Add Image", style: .done, target: self, action: #selector(handleImgUpload))
        
        let items = [imgBtn, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.postTxt.inputAccessoryView = doneToolbar
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    //MARK: API
    private func createPost() {
        
        let serverConnect = ServerConnect()
        let parameters: [String: Any] = [
            "title": "post",
            "description": postTxt.text ?? "",
            "photo2": "nil",
            "photo3": "nil"
        ]
        
        serverConnect.postRequest(url: "api/v1/user-post/", params: parameters) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(Post.self, from: data)
                    self.post = resp
                    self.navigationController?.popViewController(animated: true)
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
    
    @objc func handleImgUpload() {
        self.showAlert("Image Upload", "Going to open photolibrery ")
    }
}
