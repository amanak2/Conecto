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
    var exchanges = [Exchange]()
    
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
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(refreshExchange), for: .valueChanged)
        
        return refreshControl
    }()
    
    //MARK: VIEW CONTROLLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(ExchangeCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(collectionView)
        view.addContraintWithFormat(format: "H:|[v0]|", views: collectionView)
        view.addContraintWithFormat(format: "V:|[v0]|", views: collectionView)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refresher
        } else {
            collectionView.addSubview(refresher)
        }
        
        setupNavbar()
        getFromCore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    private func setupNavbar() {
        
        navigationController?.navigationBar.barTintColor = Theme.tintColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        
        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLbl.textColor = UIColor.white
        titleLbl.text = "Exchange"
        titleLbl.font = Theme.boldFont
        navigationItem.titleView = titleLbl
    }
    
    @objc func refreshExchange() {
        PresistentService.deleteRecords(fromEntity: "Exchange")
        UserUtil.removeObj(forKey: "exchangeNextURL")
        exchanges.removeAll()
        collectionView.reloadData()
        
        getFromCore()
        
        //ADDING DELAY
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }

    //MARK: SYNC
    
    private func getFromCore() {
        guard PresistentService.fetchExchange()! != [] else { getExchange(); return }
        self.exchanges = PresistentService.fetchExchange()!
        self.collectionView.reloadData()
    }
    
    private func getExchange() {
        let sync = Synchronizer()
        
        sync.fetchExchange { (exchanges, error) in
            if let error = error {
                print(error)
            }
            
            if let exchanges = exchanges {
                self.exchanges.append(contentsOf: exchanges)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ExchangeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchanges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ExchangeCell {
            
            let exchange = exchanges[indexPath.row]
            cell.exchange = exchange
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging == true {
            if indexPath.row == (exchanges.count - 1) {
                if UserUtil.fetchString(forKey: "exchangeNextURL") != nil {
                    self.getExchange()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 32) / 2
        
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Exchange", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ItemVC") as? ItemVC
        controller?.exchange = exchanges[indexPath.row]
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}
