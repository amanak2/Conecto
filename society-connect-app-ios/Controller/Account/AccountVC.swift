//
//  AccountVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class AccountVC: UIViewController, CellBtnPress {

    //MARK: VARIABLE
    var userResponse: UserResponse?
    var postResponse: PostResponse?
    
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
    
    //MARK: VIEWCONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFeed()
        getUser()
        setupNavbar()
        
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "Cell2")
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //MARK: API CALLS
    
    private func getUser() {
        let serverConnect = ServerConnect()
        
        serverConnect.getRequest(url: "api/v1/users/") { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                    self.userResponse = resp
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func getFeed() {
        let serverConnect = ServerConnect()
        
        serverConnect.getRequest(url: "api/v1/user-post/") { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(PostResponse.self, from: data)
                    self.postResponse = resp
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
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
        titleLbl.text = "Account"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
    }
    
    //MARK: ACTION BTNS
    func btnPressed() {
        let storyboard = UIStoryboard(name: "Account", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "EditProfileVC")
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: COLLECTION VIEW

extension AccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            guard let postCount = postResponse?.results.count else { return 0 }
            
            return postCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ProfileCell {
                
                guard let user = userResponse?.results[indexPath.row] else { return cell }
                
                cell.user = user
                cell.delegate = self
                
                return cell
            }
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as? FeedCell {
                
                guard let post = postResponse?.results[indexPath.row] else { return cell }
                
                cell.post = post
                
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
            return CGSize(width: width, height: 135)
        default:
            
            guard let post = postResponse?.results[indexPath.row] else { return CGSize.zero }
            
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
    
}
