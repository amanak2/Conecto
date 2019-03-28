//
//  Alertable.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 28/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

protocol Alertable { }

extension Alertable where Self: UIViewController {
    
    func showAlert(_ title: String, _ msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
