//
//  FeedVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import CoreData

class FeedVC: UIViewController, Alertable, FeedActionBtns {

    //MARK: VARIABLES
    var posts = [Post]()
    
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
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(refreshFeed), for: .valueChanged)
        
        return refreshControl
    }()
    
    //MARK: VIEW CONTROLLERS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CreatePostCell.self, forCellWithReuseIdentifier: "Cell2")
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresher
        } else {
            collectionView.addSubview(refresher)
        }
        
        fetchFromCore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func setupNavbar() {
        
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Connect"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
        
        let btn = UIButton()
        let btnImg = UIImage(named: "message")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(btnImg, for: .normal)
        btn.tintColor = Theme.whiteColor
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(messageBtnPressed), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.rightBarButtonItems = [btnItem]
    }
    
    @objc func refreshFeed() {
        PresistentService.deleteRecords(fromEntity: "Post")
        UserUtil.removeObj(forKey: "postNextURL")
        posts.removeAll()
        collectionView.reloadData()
        
        fetchFromCore()
        
        //ADDING DELAY
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    //MARK: CALL SYNC
    
    private func fetchFromCore() {
        guard PresistentService.fetchUserPost()! != [] else { getFeed(); return }
        self.posts = PresistentService.fetchUserPost()!
        self.collectionView.reloadData()
    }
    
    private func getFeed() {
        let sync = Synchronizer()
        
        sync.fetchUserPost { (posts, error) in
            if let error = error {
                print(error)
            }
            
            if let posts = posts {
                self.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: ACTION BTNS
    @objc func messageBtnPressed() {
        showAlert("Message", "Message Btn Pressed")
    }
    
    func commentBtnPressed(forPost postID: Int32) {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CommentVC") as? CommentVC
        controller?.postID = postID
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func likeBtnPressed(forPost postID: Int32) {
        let serverConnect = ServerConnect()
        let params: [String: Any] = [
            "post": Int("\(postID)") as Any
        ]
        
        serverConnect.postRequest(url: "api/v1/like/", params: params) { (data, error) in
            if let error = error {
                print(error)
            }
            
            if let _ = data {
                
            }
        }
    }
    
}

//MARK: COLLECTION VIEW 
extension FeedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as? CreatePostCell {
                
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FeedCell {
                
                let post = posts[indexPath.row]
                cell.post = post
                cell.delegate = self
                
                return cell
            }
        default:
            return UICollectionViewCell()
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging == true {
            if indexPath.row == (posts.count - 1) {
                if UserUtil.fetchString(forKey: "postNextURL") != nil {
                    self.getFeed()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let aspect: CGFloat = 4/5
        let width = view.frame.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 70)
        default:
            
            let approximaeWidth = view.frame.width
            let size = CGSize(width: approximaeWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: Theme.mediumFont]
            
            let desc = posts[indexPath.row].desc
            let estimatedFrame = NSString(string: desc!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            if let _ = posts[indexPath.row].photo1 {
                let height = (width + 16) * aspect
                return CGSize(width: width, height: 127 + estimatedFrame.height + height)
            }
            
            return CGSize(width: width, height: estimatedFrame.height + 127)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        
        switch indexPath.section {
        case 0:
            let controller = storyboard.instantiateViewController(withIdentifier: "CreatePostVC")
            self.navigationController?.pushViewController(controller, animated: true)
            
        default:
            
            let controller = storyboard.instantiateViewController(withIdentifier: "PostVC") as? PostVC
            controller?.post = self.posts[indexPath.row]
            self.navigationController?.pushViewController(controller!, animated: true)
            
        }
    }
}
