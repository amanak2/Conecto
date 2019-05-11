//
//  SearchCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class SearchCell: BaseCell {
    
    //MARK: DATA
    var user: User? {
        didSet {
            usernameLbl.text = user?.username
            
            if let p_img = user?.profilePic {
                profileImg.sd_setImage(with: URL(string: p_img), completed: nil)
            }
        }
    }
    
    //MARK: ELEMENTS
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = Theme.lightGrey
        img.layer.cornerRadius = 22
        img.clipsToBounds = true
        return img
    }()
    
    let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Username"
        lbl.font = Theme.largeFont
        return lbl
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
        addSubview(usernameLbl)
        addSubview(seprationView)
        
        addContraintWithFormat(format: "H:|-8-[v0(44)]-8-[v1]-8-|", views: profileImg, usernameLbl)
        addContraintWithFormat(format: "V:|-17-[v0]", views: usernameLbl)
        addContraintWithFormat(format: "V:|-8-[v0(44)]-8-[v1(1)]", views: profileImg, seprationView)
        addContraintWithFormat(format: "H:|[v0]|", views: seprationView)
    }
    
}
