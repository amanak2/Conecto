//
//  AppDelegate.swift
//  society-connect-app-ios
//
//  Created by Aman Chawla on 27/03/19.
//  Copyright © 2019 Aman Chawla. All rights reserved.
//

import UIKit
import FacebookCore
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //keyboard manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        //FB_login
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        let isLoggedIn = UserUtil.fetchBool(forKey: "isLoggedIn")
        let isSocietySelected = UserUtil.fetchBool(forKey: "isSocietySelected")
        
        //app init
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if isLoggedIn == false {
            let controller = storyboard.instantiateViewController(withIdentifier: "LaunchVC")
            navigationController = UINavigationController(rootViewController: controller)
            
        } else if isLoggedIn == true {
            if isSocietySelected == false {
                let controller = storyboard.instantiateViewController(withIdentifier: "SelectSocietyVC")
                navigationController = UINavigationController(rootViewController: controller)
                
            } else {
                let controller = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                navigationController = UINavigationController(rootViewController: controller)
            }
        }
        
        navigationController?.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

