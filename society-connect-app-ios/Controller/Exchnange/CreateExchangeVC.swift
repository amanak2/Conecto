//
//  CreateExchangeVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 11/05/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CreateExchangeVC: UIViewController, UITextViewDelegate, Alertable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: VARIABLEs
    let imagePicker = UIImagePickerController()
    
    //MARK: ELEMENTSs
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var itemTitle: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        descTV.delegate = self
        setupNavbar()
        
        descTV.text = "Enter Description..."
        descTV.textColor = Theme.lightGrey
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        priceLbl.keyboardType = .numberPad
        
        setupNavbar()
    }
    
    private func setupNavbar() {
        
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Create Exchange Item"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
        
        let btn = UIButton()
        btn.setTitle("Cancel", for: .normal)
        btn.tintColor = Theme.whiteColor
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(cancelCreatePost), for: .touchUpInside)
        let btnItem = UIBarButtonItem()
        btnItem.customView = btn
        
        self.navigationItem.leftBarButtonItems = [btnItem]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter Description..." {
            descTV.text = ""
            descTV.textColor = UIColor.black
        }
    }
    
    //MARK: ACTION BTNs
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if itemTitle.text != "" && priceLbl.text != "" {
            createPost()
        } else {
            self.showAlert("Empty Fields", "Please make sure all fields are filled")
        }
        
    }
    
    @objc func cancelCreatePost() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imgBtnPressed(_ sender: Any) {
        let alertController = UIAlertController()
        imagePicker.delegate = self
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) == true {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert("Camera", "Camera is not available on this device or accesibility has been revoked!")
            }
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { (cameraAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) == true {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                self.showAlert("Photo Library", "Photo Library is not available on this device or accesibility has been revoked!")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgView.image = pickedImg
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: API
    private func createPost() {
        
        let serverConnect = ServerConnect()
        let parameters: [String: String] = [
            "title": itemTitle.text ?? "",
            "description": descTV.text ?? "",
            "price": priceLbl.text ?? "",
            "photo2": "nil",
            "photo3": "nil"
        ]
        
        var media = [Media]()
        if let img = imgView.image {
            let photo1 = Media(withImg: img, forKey: "photo1")
            media.append(photo1!)
        } else {
            media.removeAll()
        }
        
        serverConnect.multipartPostRequest(url: "api/v1/exchange-items/", method: .post, params: parameters, media: media) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let _ = try JSONDecoder().decode(ExchangeModel.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } catch let err{
                    print(err)
                }
            }
        }
        
    }
    
}
