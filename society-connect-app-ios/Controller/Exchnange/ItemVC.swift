//
//  ItemVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 05/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import SDWebImage

class ItemVC: UIViewController {

    //MARK: VARIABLE
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height)
    var descHeight: CGFloat = 0
    var imgHeight: CGFloat = 0
    
    var exchange: Exchange? {
        didSet {
            
            itemNameLbl.text = exchange?.title
            priceLbl.text = "₹\(exchange?.price ?? "0")"
            descLbl.text = exchange?.desc
            
            if let img = exchange?.photo1 {
                itemImg.sd_setImage(with: URL(string: img), completed: nil)
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
    
    let itemImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let itemNameLbl: UILabel = {
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
    
    let descLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Theme.mediumFont
        lbl.numberOfLines = 0
        //lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var contactBtn: MainBtn = {
        let btn = MainBtn()
        btn.setTitle("Contact Seller", for: .normal)
        btn.layer.cornerRadius = 18
        btn.addTarget(self, action: #selector(handleContactBtn), for: .touchUpInside)
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
        btn.setTitle("Back", for: .normal)
        btn.tintColor = Theme.whiteColor
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.leftBarButtonItems = [btnItem]
    }
    
    private func setupContentView() {
        contentView.addSubview(itemImg)
        contentView.addSubview(itemNameLbl)
        contentView.addSubview(priceLbl)
        contentView.addSubview(descLbl)
        contentView.addSubview(contactBtn)
        
        let approximaeWidth = view.frame.width
        let size = CGSize(width: approximaeWidth, height: 1000)
        let attributes = [NSAttributedString.Key.font: Theme.mediumFont]
        
        let aspect: CGFloat = 4/5
        let width = view.frame.width
        
        if let desc = exchange?.desc {
            let estimatedFrame = NSString(string: desc).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            descHeight = estimatedFrame.height
        }
        
        if let _ = exchange?.photo1 {
            imgHeight = (width) * aspect
        }
        
        contentViewSize = CGSize(width: width, height: 120 + descHeight + imgHeight)
        scrollView.contentSize = contentViewSize
        contentView.frame.size = contentViewSize
        
        contentView.addContraintWithFormat(format: "H:|[v0]|", views: itemImg)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: itemNameLbl)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: priceLbl)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: descLbl)
        contentView.addContraintWithFormat(format: "H:|-8-[v0]-8-|", views: contactBtn)
        
        contentView.addContraintWithFormat(format: "V:|[v0(\(imgHeight))]", views: itemImg)
        contentView.addContraintWithFormat(format: "V:[v0(36)]", views: contactBtn)
        
        itemNameLbl.topAnchor.constraint(equalToSystemSpacingBelow: itemImg.bottomAnchor, multiplier: 1).isActive = true
        priceLbl.topAnchor.constraint(equalToSystemSpacingBelow: itemNameLbl.bottomAnchor, multiplier: 1).isActive = true
        descLbl.topAnchor.constraint(equalToSystemSpacingBelow: priceLbl.bottomAnchor, multiplier: 1).isActive = true
        contactBtn.topAnchor.constraint(equalToSystemSpacingBelow: descLbl.bottomAnchor, multiplier: 1).isActive = true
    }
    
    //MARK: ACTION BTN
    @objc func backBtn() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleContactBtn() {
        
    }

}
