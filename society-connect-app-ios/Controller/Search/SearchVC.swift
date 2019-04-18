//
//  SearchVC.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 06/04/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {

    //MARK: VARIABLES
    var response: UserResponse?
    
    //MARK: ELEMENTS
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.sizeToFit()
        sb.placeholder = "Search"
        sb.showsCancelButton = true
        sb.delegate = self
        return sb
    }()
    
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
        getUsers()
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        setupNavbar()
    }

    private func setupNavbar() {
        
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        let searchBarItem = UIBarButtonItem(customView: searchBar)
        let attributes = [NSAttributedString.Key.foregroundColor : Theme.whiteColor]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        self.navigationItem.leftBarButtonItem = searchBarItem
    }
    
    //MARK: API CALL
    private func getUsers() {
        
        let serverConnect = ServerConnect()
        
        serverConnect.getRequest(url: "api/v1/users/?show_society=true") { (data, error) in
            
            if let error = error {
                //self.showAlert("ERROR", "Something went Wrong")
                print(error)
            }
            
            if let data = data {
                do {
                    let resp = try JSONDecoder().decode(UserResponse.self, from: data)
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
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let userCount = response?.results.count else { return 0 }
        return userCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SearchCell {
            
            guard let user = response?.results[indexPath.row] else { return cell }
            
            cell.user = user
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        
        return CGSize(width: width, height: 61)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
