//
//  FeedVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class FeedVC: UIViewController, Alertable {

    //MARK: VARIABLES
    var response: PostResponse?
    
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
        
        getFeed()
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
        titleLbl.font = Theme.largeFont
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
    
    //MARK: API CALL
    private func getFeed() {
        
        let serverConnect = ServerConnect()
        
        serverConnect.getRequest(url: "api/v1/user-post/?show_society=true") { (data, error) in
            
            if let error = error {
                //self.showAlert("ERROR", "Something went Wrong")
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(PostResponse.self, from: data)
                    self.response = resp
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    //MARK: ACTION BTNS
    @objc func messageBtnPressed() {
        showAlert("Message", "Message Btn Pressed")
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
        default:
            guard let postCount = response?.results.count else { return 0 }
            
            return postCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as? CreatePostCell {
                
                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? FeedCell {
                
                guard let posts = response?.results else { return cell }
                
                cell.post = posts[indexPath.row]
                cell.layoutIfNeeded()
                
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let aspect: CGFloat = 4/5
        let width = view.frame.width
        
        switch indexPath.section {
        case 0:
            return CGSize(width: width, height: 70)
        default:
            
            guard let post = response?.results[indexPath.row] else { return CGSize.zero }
            
            let approximaeWidth = view.frame.width
            let size = CGSize(width: approximaeWidth, height: 1000)
            let attributes = [NSAttributedString.Key.font: Theme.mediumFont]
            
            let estimatedFrame = NSString(string: post.description!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            if post.photo1 != nil {
                let height = (width) * aspect
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
            
            let controller = storyboard.instantiateViewController(withIdentifier: "PostVC")
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
    }
}
