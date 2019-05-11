//
//  ProfileCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 24/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: BaseCell {
    
    //MARK: DATA
    var delegate: CellBtnPress?
    
    var user: User? {
        didSet {
            if user?.firstName != "" {
                self.nameLbl.text = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            } else {
                self.nameLbl.text = user?.username
            }
            
            self.societyName.text = user?.society?.name ?? ""
            self.sectorName.text = user?.society?.address ?? ""
            
            if let img = user?.profilePic {
                self.profileImg.sd_setImage(with: URL(string: img), completed: nil)
            }
            
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
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
        return img
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.boldFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let societyName: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    let sectorName: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.lightGray
        return lbl
    }()
    
    lazy var editProfileBtn: MainBtn = {
        let btn = MainBtn()
        btn.setTitle("Edit Profile", for: .normal)
        btn.layer.cornerRadius = 18
        btn.addTarget(self, action: #selector(handleEditBtnPressed), for: .touchUpInside)
        return btn
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
        addSubview(containerView)
        addSubview(editProfileBtn)
        addSubview(seprationView)
        
        addContraintWithFormat(format: "H:|-8-[v0(60)]-10-[v1]-8-|", views: profileImg, containerView)
        addContraintWithFormat(format: "V:|-8-[v0(60)]", views: profileImg)
        
        addContraintWithFormat(format: "V:|-10-[v0(70)]-10-[v1(36)]-8-[v2(1)]|", views: containerView ,editProfileBtn, seprationView)
        addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: editProfileBtn)
        addContraintWithFormat(format: "H:|[v0]|", views: seprationView)
        
        setupContainer()
    }
    
    private func setupContainer() {
        containerView.addSubview(nameLbl)
        containerView.addSubview(societyName)
        containerView.addSubview(sectorName)
        
        containerView.addContraintWithFormat(format: "H:|[v0]|", views: nameLbl)
        containerView.addContraintWithFormat(format: "H:|[v0]|", views: societyName)
        containerView.addContraintWithFormat(format: "H:|[v0]|", views: sectorName)
        
        containerView.addContraintWithFormat(format: "V:|[v0]-5-[v1]-5-[v2]|", views: nameLbl, societyName, sectorName)
    }
    
    //MARK: ACTION BTNS
    @objc func handleEditBtnPressed() {
        delegate?.btnPressed()
    }
    
}
