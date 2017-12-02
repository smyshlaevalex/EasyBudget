//
//  AppDelegate.swift
//  Budget
//
//  Created by Alexander Smyshlaev on 11/30/16.
//  Copyright © 2016 Alexander Smyshlaev. All rights reserved.
//

import UIKit
import Chameleon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    enum LaunchType: String {
        case openTransactionCreator = "openTransactionCreator"
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let storyboard = UIStoryboard(name: "iPad_Main", bundle: nil)
            
            window?.rootViewController = storyboard.instantiateInitialViewController()
        }
        
        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.flatMintDark, with: .contrast)
        
        UIButton.appearance(whenContainedInInstancesOf: [UIView.self]).backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        return true
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let openAction = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "openAction" })?.value else {
            return false
        }
        
        guard let launchType = LaunchType(rawValue: openAction) else {
            return false
        }
        
        switch launchType {
        case .openTransactionCreator:
            let mainViewController: UIViewController?
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                mainViewController = ((UIApplication.shared.keyWindow?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController)?.visibleViewController
            } else {
                mainViewController = (((UIApplication.shared.keyWindow?.rootViewController as? UISplitViewController)?.viewControllers.first as? UITabBarController)?.selectedViewController as? UINavigationController)?.visibleViewController
            }
            
            if let viewController  = mainViewController {
                AddTransaction.presentAddTransactionViewsWithViewController(viewController)
            }
        }
        
        return true
    }
}

