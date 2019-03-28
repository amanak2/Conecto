//
//  MainBtn.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 28/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class MainBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupBtn()
    }
    
    private func setupBtn() {
        layer.cornerRadius = frame.height / 2
        
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize.zero
        
        setTitleColor(Theme.whiteColor, for: .normal)
        titleLabel?.font = Theme.mediumFont
    }
    
}
