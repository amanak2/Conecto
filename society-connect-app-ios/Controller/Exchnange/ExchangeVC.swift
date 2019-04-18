//
//  ExchangeVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class ExchangeVC: UIViewController {
    
    //MARK: VARIABLES
    
    //MARK: ELEMENTS
    
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
    }
    
    private func setupNavbar() {
        
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Exchange"
        titleLbl.font = Theme.largeFont
        navigationItem.titleView = titleLbl
    }

}
