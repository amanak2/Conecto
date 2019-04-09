//
//  CardView.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 29/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    private func setupView() {
        
        layer.cornerRadius = 10
        
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        
        backgroundColor = Theme.whiteColor
        
    }
    
}
