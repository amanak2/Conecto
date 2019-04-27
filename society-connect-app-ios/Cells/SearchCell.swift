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
    var user: UserModel? {
        didSet {
            usernameLbl.text = user?.username
        }
    }
    
    //MARK: ELEMENTS
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.blue
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
