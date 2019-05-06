//
//  ExchangeCell.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class ExchangeCell: BaseCell {
    
    //MARK: DATA
    var exchange: Exchange? {
        didSet {
            
            titleLbl.text = exchange?.title
            priceLbl.text = "₹\(exchange?.price ?? "0")"
            
            if let img = exchange?.photo1 {
                itemImg.sd_setImage(with: URL(string: img), completed: nil)
            }
            
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
    
    let itemImg: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 10
        img.backgroundColor = Theme.lightGrey
        return img
    }()
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.boldFont
        return lbl
    }()
    
    let priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.largeFont
        lbl.textColor = UIColor(red:0.13, green:0.42, blue:0.16, alpha:1.0)
        return lbl
    }()
    
    //MARK: CELL
    override func setupView() {
        addSubview(cardView)
        cardView.addSubview(containerView)
        
        addContraintWithFormat(format: "H:|-1-[v0]-1-|", views: cardView)
        addContraintWithFormat(format: "V:|-8-[v0]-8-|", views: cardView)
        
        cardView.addContraintWithFormat(format: "H:|[v0]|", views: containerView)
        cardView.addContraintWithFormat(format: "V:|[v0]|", views: containerView)
        
        setupContainerView()
    }
    
    private func setupContainerView() {
        containerView.addSubview(itemImg)
        containerView.addSubview(titleLbl)
        containerView.addSubview(priceLbl)
        
        containerView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: itemImg)
        containerView.addContraintWithFormat(format: "V:|-8-[v0(160)]-8-[v1]-6-[v2]-8-|", views: itemImg, titleLbl, priceLbl)
        containerView.addContraintWithFormat(format: "H:|-10-[v0]-8-|", views: titleLbl)
        containerView.addContraintWithFormat(format: "H:|-10-[v0]-8-|", views: priceLbl)
    }
    
}
