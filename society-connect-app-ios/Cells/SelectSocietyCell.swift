//
//  SelectSocietyCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 09/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class SelectSocietyCell: BaseCell {
    
    //MARK: DATA
    var society: Society? {
        didSet {
            titleLbl.text = society?.name
            subtitleLbl.text = "\(society?.address ?? ""), \(society?.city ?? "")"
        }
    }
    
    //MARK: ELEMENTS
    let cardView: CardView = {
        let view = CardView()
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "thumbnail")
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.whiteColor
        view.alpha = 0.9
        return view
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Society Name"
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    let subtitleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Address goes here"
        lbl.textColor = UIColor.lightGray
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        return lbl
    }()
    
    //MARK: CELL
    override func setupView() {
        addSubview(cardView)
        cardView.addSubview(containerView)
        
        addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: cardView)
        addContraintWithFormat(format: "V:|-8-[v0]-8-|", views: cardView)
        
        cardView.addContraintWithFormat(format: "H:|[v0]|", views: containerView)
        cardView.addContraintWithFormat(format: "V:|[v0]|", views: containerView)
        
        setupContainerView()
    }
    
    private func setupContainerView() {
        containerView.addSubview(imgView)
        containerView.addSubview(bannerView)
        
        containerView.addContraintWithFormat(format: "H:|[v0]|", views: imgView)
        containerView.addContraintWithFormat(format: "V:|[v0]|", views: imgView)
        
        containerView.addContraintWithFormat(format: "H:|[v0]|", views: bannerView)
        
        let bannerHeight = frame.height/3.5
        
        containerView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: bannerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: bannerHeight))
        
        setupBannerView()
    }
    
    private func setupBannerView() {
        bannerView.addSubview(titleLbl)
        bannerView.addSubview(subtitleLbl)
        
        bannerView.addContraintWithFormat(format: "H:|-16-[v0]-16-|", views: titleLbl)
        bannerView.addContraintWithFormat(format: "H:|-16-[v0]-16-|", views: subtitleLbl)
        
        bannerView.addContraintWithFormat(format: "V:|-10-[v0]-5-[v1]-8-|", views: titleLbl, subtitleLbl)
    }
    
}
