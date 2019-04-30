//
//  SelectSocietyVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 09/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class SelectSocietyVC: UIViewController {

    //MARK: VARIABLES
    var response: SocietyResponse?
    var selectedSociety: Int?
    
    //MARK: ELEMENTS
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = Theme.whiteColor
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        collectionView.register(SelectSocietyCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        setupNavbar()
        getSociety()
        getUser()
    }
    
    private func setupNavbar() {
        
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Select Society"
        titleLbl.font = Theme.largeFont
        navigationItem.titleView = titleLbl
        
    }
    
    //MARK: API CALL
    private func getSociety() {

        let serverConnect = ServerConnect()
        
        let urlString = "\(BASE_URL)api/v1/society/"
        let url = URL(string: urlString)

        serverConnect.getRequest(url: url!) { (data, error) in

            if let error = error {
                print(error)
            }

            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(SocietyResponse.self, from: data)
                    self.response = resp

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func updateUserSociety(societyID: Int) {
        
        let serverConnect = ServerConnect()
        
        let params = ["society": societyID]
        
        if let userID = UserUtil.fetchInt(forKey: "ME") {
            serverConnect.patchRequest(url: "api/v1/users/\(userID)/", params: params) { (data, error) in
                if let _ = error {
                    
                }
                
                if let _ = data {
                    UserUtil.saveBool(withValue: true, forKey: "isSocietySelected")
                }
            }
        }
    }
    
    private func getUser() {
        let serverConnect = ServerConnect()
        
        let urlString = "\(BASE_URL)api/v1/users/"
        let url = URL(string: urlString)
        
        serverConnect.getRequest(url: url!) { (data, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(UserResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let id = resp.results.first?.id
                        UserUtil.saveInt(withValue: id!, forKey: "ME")
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
}

extension SelectSocietyVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let societyCount = response?.results.count else { return 0 }
        return societyCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SelectSocietyCell {
            
            guard let society = response?.results[indexPath.row] else { return cell }
            cell.society = society
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let aspect: CGFloat = 9/16
        let width = view.frame.width
        let height = (width) * aspect
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectSocietyCell {
            self.selectedSociety = cell.society?.id
            if selectedSociety != nil {
                
                self.updateUserSociety(societyID: selectedSociety!)
                navigationController?.isNavigationBarHidden = true
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
}
