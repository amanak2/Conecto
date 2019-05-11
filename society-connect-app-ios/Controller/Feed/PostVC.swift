//
//  PostVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 18/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    //MAK: VARIABLES
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height)
    var postTextHeight: CGFloat = 0
    var imgHeight: CGFloat = 0
    
    var post: Post? {
        didSet {
            nameLbl.text = post?.user!.username
            postText.text = post?.desc
            subtitleLbl.text = UserUtil.timeAgoSinceDate(fromStringUTC: post!.created!)
            likeCount.text = "\(post?.likes ?? 0) Likes"
            
            let likeImg = post!.likedByCurrentUser ? UIImage(named: "like") : UIImage(named: "unlike")
            likeBtn.setImage(likeImg, for: .normal)
            
            if let img = post?.photo1 {
                postImg.sd_setImage(with: URL(string: img))
            }
            
            if let p_img = post?.user?.profilePic {
                profileImg.sd_setImage(with: URL(string: p_img))
            }
        }
    }
    
    //MARK: ELEMENTS
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = Theme.whiteColor
        sv.frame = view.bounds
        sv.contentSize = contentViewSize
        return sv
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.whiteColor
        view.frame.size = contentViewSize
        return view
    }()
    
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.blue
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 22
        img.clipsToBounds = true
        return img
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        //lbl.text = "amanchawla"
        lbl.font = Theme.mediumFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let subtitleLbl: UILabel = {
        let lbl = UILabel()
        //lbl.text = "10 mins ago"
        lbl.font = Theme.smallFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    let postText: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let postImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let actionView: UIView = {
        let view = UIView()
        return view
    }()
    
    let likeCount: UILabel = {
        let lbl = UILabel()
        //lbl.text = "100 Likes"
        return lbl
    }()
    
    let commentBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "comment"), for: .normal)
        btn.addTarget(self, action: #selector(commentBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    let likeBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "unlike"), for: .normal)
        return btn
    }()
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupContentView()
        setupNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
    }
    
    private func setupNavbar() {
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
    
    private func setupContentView() {
        contentView.addSubview(profileImg)
        contentView.addSubview(nameLbl)
        contentView.addSubview(subtitleLbl)
        contentView.addSubview(postText)
        contentView.addSubview(postImg)
        contentView.addSubview(actionView)
        
        let approximaeWidth = view.frame.width
        let size = CGSize(width: approximaeWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: Theme.mediumFont]
        
        let aspect: CGFloat = 4/5
        let width = view.frame.width
        
        if let desc = post?.desc {
            let estimatedFrame = NSString(string: desc).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            postTextHeight = estimatedFrame.height
        }
        
        if let _ = post?.photo1 {
            imgHeight = (width + 16) * aspect
        }
        
        contentViewSize = CGSize(width: width, height: 127 + postTextHeight + imgHeight)
        scrollView.contentSize = contentViewSize
        contentView.frame.size = contentViewSize
        
        contentView.addContraintWithFormat(format: "H:|-8-[v0(44)]", views: profileImg)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: postText)
        contentView.addContraintWithFormat(format: "H:|[v0]|", views: postImg)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: actionView)
        contentView.addContraintWithFormat(format: "V:|-8-[v0(44)]-8-[v1]", views: profileImg, postText)
        
        contentView.addContraintWithFormat(format: "H:|-60-[v0]-8-|", views: nameLbl)
        contentView.addContraintWithFormat(format: "H:|-60-[v0]-8-|", views: subtitleLbl)
        contentView.addContraintWithFormat(format: "V:|-8-[v0]-2-[v1]", views: nameLbl, subtitleLbl)
        
        contentView.addConstraint(NSLayoutConstraint(item: postImg, attribute: .top, relatedBy: .equal, toItem: postText, attribute: .bottom, multiplier: 1, constant: 10))
        contentView.addContraintWithFormat(format: "V:[v0(\(imgHeight))]", views: postImg)
        
        contentView.addConstraint(NSLayoutConstraint(item: actionView, attribute: .top, relatedBy: .equal, toItem: postImg, attribute: .bottom, multiplier: 1, constant: 8))
        
        setupActionView()
    }
    
    private func setupActionView() {
        actionView.addSubview(likeBtn)
        actionView.addSubview(commentBtn)
        actionView.addSubview(likeCount)
        
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: likeBtn)
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: commentBtn)
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: likeCount)
        actionView.addContraintWithFormat(format: "H:|-2-[v0]-10-[v1]-10-[v2]", views: likeBtn, commentBtn, likeCount)
    }

    //MARK: ACTION BTN
    @objc func backBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func commentBtnPressed() {
        let storyboard = UIStoryboard(name: "Feed", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CommentVC") as? CommentVC
        controller?.postID = post?.id
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
