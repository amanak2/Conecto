//
//  CommentVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 18/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CommentVC: UIViewController, Alertable {

    //MARK: VARIBLESs
    var postID: Int32?
    var comments = [CommentModel]()
    var bottomPadding: CGFloat = 0
    var inputContainerBottomConstraint: NSLayoutConstraint?
    
    //MARK: ELEMENTS
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Theme.whiteColor
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.whiteColor
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(Theme.tintColor, for: .normal)
        button.titleLabel?.font = Theme.largeFont
        button.addTarget(self, action: #selector(handleSendButtonPress), for: .touchUpInside)
        return button
    }()
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        view.addSubview(collectionView)
        view.addSubview(inputContainerView)
        
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]-44-|", views: collectionView)
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceVertical = true
        
        view.addContraintWithFormat(format: "H:|[v0]|", views: inputContainerView)
        view.addContraintWithFormat(format: "V:[v0(44)]", views: inputContainerView)
        
        let window = UIApplication.shared.keyWindow
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        
        inputContainerBottomConstraint = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -bottomPadding)
        view.addConstraint(inputContainerBottomConstraint!)
        
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(CommentVC.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getComments()
        setupInputView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }

    private func setupNavbar() {
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Comments"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
        
        let btn = UIButton()
        let btnImg = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(btnImg, for: .normal)
        btn.tintColor = Theme.whiteColor
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.leftBarButtonItems = [btnItem]
    }
    
    private func setupInputView() {
        let boardline = UIView()
        boardline.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        inputContainerView.addSubview(inputTextField)
        inputContainerView.addSubview(sendButton)
        inputContainerView.addSubview(boardline)
        
        inputContainerView.addContraintWithFormat(format: "H:|-8-[v0]-8-[v1(60)]-8-|", views: inputTextField, sendButton)
        inputContainerView.addContraintWithFormat(format: "V:|[v0]|", views: inputTextField)
        inputContainerView.addContraintWithFormat(format: "V:|[v0]|", views: sendButton)
        
        inputContainerView.addContraintWithFormat(format: "H:|[v0]|", views: boardline)
        inputContainerView.addContraintWithFormat(format: "V:|[v0(1)]", views: boardline)
    }
    
    //MARK: API CALL
    private func getComments() {
        let serverConnect = ServerConnect()
        let url: URL?
        
        if UserUtil.fetchString(forKey: "commentNextURL") != nil {
            url = URL(string: UserUtil.fetchString(forKey: "commentNextURL")!)
        } else {
            let urlString = "\(BASE_URL)api/v1/comment/?on_post=\(postID!)"
            url = URL(string: urlString)
        }
        
        serverConnect.getRequest(url: url!) { (data, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(CommentResponse.self, from: data)
                    
                    if let next = resp.next {
                        UserUtil.saveString(withValue: next, forKey: "commentNextURL")
                    } else {
                        UserUtil.removeObj(forKey: "commentNextURL")
                    }
                    
                    let results = resp.results
                    results.forEach({ (result) in
                        self.comments.append(result)
                    })
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        let lastItem = self.comments.count - 1
                        let indexPath = IndexPath(item: lastItem, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                    
                } catch let err {
                    print(err)
                }
            }
        }
    }
    
    private func postComment() {
        let serverConnect = ServerConnect()
        
        let params: [String: Any] = [
            "post": postID as Any,
            "comment": inputTextField.text ?? ""
        ]
        
        serverConnect.postRequest(url: "api/v1/comment/", params: params) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let comment = try JSONDecoder().decode(CommentModel.self, from: data)
                    self.comments.append(comment)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        
                        let lastItem = self.comments.count - 1
                        let indexPath = NSIndexPath(item: lastItem, section: 0)
                        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                        
                        self.inputTextField.text = ""
                    }
                } catch let err {
                    print(err)
                }
            }
            
        }
    }
    
    //MARK: HANDLE KEYBOARD
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            
            let isKeyboardShowing = notification.name.rawValue == UIResponder.keyboardWillShowNotification.rawValue
            
            inputContainerBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : -bottomPadding
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }) { (completed) in
                
                if isKeyboardShowing {
                    if completed {
                        let lastItem = self.comments.count - 1
                        let indexPath = IndexPath(item: lastItem, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                } 
            }
            
        }
    }
    
    //MARK: ACTION BTNS
    @objc func backBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSendButtonPress() {
        
        if inputTextField.text != "" {
            postComment()
        } else {
            self.showAlert("Empty TextField", "Please write a comment before sending!")
        }
        
    }
}

extension CommentVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CommentCell {
            
            cell.comment = comments[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let approximaeWidth = view.frame.width
        let size = CGSize(width: approximaeWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: Theme.mediumFont]
        
        let comment = comments[indexPath.row].comment
        let estimatedFrame = NSString(string: comment).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: approximaeWidth, height: 52 + estimatedFrame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
}
