//
//  CommentCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 04/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCell: BaseCell {
    
    //MARK: DATA
    var comment: CommentModel? {
        didSet {
            
            if let img = comment?.user.profilePic {
                profileImg.sd_setImage(with: URL(string: img), completed: nil)
            }
            
            usernameLbl.text = comment?.user.username
            commentTV.text = comment?.comment
        }
    }
    
    //MARK: ELEMENT
    
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.blue
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 22
        img.clipsToBounds = true
        return img
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Theme.lightGrey
        return view
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    let commentTV: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    //MARK: CELL
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImg.image = nil
        
        self.profileImg.sd_cancelCurrentImageLoad()
    }
    
    override func setupView() {
        addSubview(profileImg)
        addSubview(containerView)
        
        addContraintWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-|", views: profileImg, containerView)
        addContraintWithFormat(format: "V:|-8-[v0(44)]", views: profileImg)
        addContraintWithFormat(format: "V:|-8-[v0]-8-|", views: containerView)
        
        setupContainerView()
    }
    
    private func setupContainerView() {
        containerView.addSubview(usernameLbl)
        containerView.addSubview(commentTV)
        
        containerView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: usernameLbl)
        containerView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: commentTV)
        
        containerView.addContraintWithFormat(format: "V:|-8-[v0][v1]-8-|", views: usernameLbl, commentTV)
    }
    
}
