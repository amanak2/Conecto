//
//  FeedCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class FeedCell: BaseCell {
    
    //MARK: DATA
    var delegate: FeedActionBtns? = nil
    
    var post: Post? {
        didSet {
            nameLbl.text = post?.user?.username
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
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = Theme.lightGrey
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
    
    let seprationView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.lightGrey
        return view
    }()
    
    let likeCount: UILabel = {
        let lbl = UILabel()
        //lbl.text = "100 Likes"
        return lbl
    }()
    
    lazy var commentBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(commentBtnPress), for: .touchUpInside)
        btn.setImage(UIImage(named: "comment"), for: .normal)
        return btn
    }()
    
    lazy var likeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
        btn.setImage(UIImage(named: "unlike"), for: .normal)
        return btn
    }()
    
    //MARK: CELL
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImg.image = nil
        self.profileImg.image = nil
        
        self.postImg.sd_cancelCurrentImageLoad()
        self.profileImg.sd_cancelCurrentImageLoad()
    }
    
    override func setupView() {
        addSubview(profileImg)
        addSubview(nameLbl)
        addSubview(subtitleLbl)
        addSubview(postText)
        addSubview(postImg)
        addSubview(actionView)
        addSubview(seprationView)
        
        addContraintWithFormat(format: "H:|-8-[v0(44)]", views: profileImg)
        addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: postText)
        addContraintWithFormat(format: "H:|[v0]|", views: postImg)
        addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: actionView)
        addContraintWithFormat(format: "H:|[v0]|", views: seprationView)
        addContraintWithFormat(format: "V:|-8-[v0(44)]-8-[v1]-10-[v2]-8-[v3(26)]-8-[v4(10)]|", views: profileImg, postText, postImg, actionView, seprationView)
        
        addContraintWithFormat(format: "H:|-60-[v0]-8-|", views: nameLbl)
        addContraintWithFormat(format: "H:|-60-[v0]-8-|", views: subtitleLbl)
        addContraintWithFormat(format: "V:|-8-[v0]-2-[v1]", views: nameLbl, subtitleLbl)
        
        setupActionView()
    }
    
    private func setupActionView() {
        actionView.addSubview(likeBtn)
        actionView.addSubview(commentBtn)
        actionView.addSubview(likeCount)
        
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: likeBtn)
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: commentBtn)
        actionView.addContraintWithFormat(format: "V:|[v0]|", views: likeCount)
        actionView.addContraintWithFormat(format: "H:|-2-[v0(26)]-10-[v1(26)]-10-[v2]", views: likeBtn, commentBtn, likeCount)
    }
    
    //MARK: ACTION BTN
    @objc func commentBtnPress() {
        delegate?.commentBtnPressed(forPost: post!.id)
    }
    
    @objc func likeBtnPressed() {
        likeCount.text = "\((post!.likes + 1)) Likes"
        delegate?.likeBtnPressed(forPost: post!.id)
    }
}
