//
//  CreatePostCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 07/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class CreatePostCell: BaseCell {
    
    //MARK: DATA
    var user: User? {
        didSet {
            
            if let p_img = user!.profilePic {
                profileImg.sd_setImage(with: URL(string: p_img), completed: nil)
            }
        }
    }
    
    //MARK: ELEMENTS
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = Theme.lightGrey
        img.layer.cornerRadius = 24
        img.clipsToBounds = true
        return img
    }()
    
    let postLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "What's on your mind?"
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    let photoImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "photo")
        return img
    }()
    
    let seprationView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.lightGrey
        return view
    }()
    
    //MARK: CELL
    override func prepareForReuse() {
        super.prepareForReuse()
        self.profileImg.image = nil
        self.profileImg.sd_cancelCurrentImageLoad()
    }
    
    override func setupView() {
        addSubview(profileImg)
        addSubview(postLbl)
        addSubview(photoImg)
        addSubview(seprationView)
        
        addContraintWithFormat(format: "H:|-8-[v0(48)]-8-[v1]-8-[v2]-8-|", views: profileImg, postLbl, photoImg)
        addContraintWithFormat(format: "V:|-8-[v0(48)]", views: profileImg)
        addContraintWithFormat(format: "V:|-20-[v0]", views: postLbl)
        addContraintWithFormat(format: "V:|-18-[v0]", views: photoImg)
        
        addContraintWithFormat(format: "H:|[v0]|", views: seprationView)
        addContraintWithFormat(format: "V:[v0(1)]|", views: seprationView)
    }
    
}
