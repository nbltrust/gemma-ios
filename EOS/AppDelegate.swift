//
//  AppDelegate.swift
//  EOS
//
//  Created by koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import SwiftyBeaver
import IQKeyboardManagerSwift
import SwiftyUserDefaults
import Localize_Swift
import Fabric
import Crashlytics
import SwiftDate
import URLNavigator
import MonkeyKing

let log = SwiftyBeaver.self
let navigator = Navigator()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self, Answers.self])
        URLNavigationMap.initialize(navigator: navigator)

        let console = ConsoleDestination()
        log.addDestination(console)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //    KingfisherManager.shared.defaultOptions = [.fromMemoryCacheOrRefresh]
//        WalletManager.shared.removeWallet(WalletManager.shared.currentPubKey)
//        WalletManager.shared.switchToLastestWallet()
        
        _ = RichStyle.init()
        RichStyle.shared.start()

        window?.rootViewController = AppConfiguration.shared.appCoordinator.rootVC
        self.window?.makeKeyAndVisible()
        
        AppConfiguration.shared.appCoordinator.start()
        RealReachability.sharedInstance().startNotifier()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.realReachabilityChanged, object: nil, queue: nil) { (notifi) in
            self.handlerNetworkChanged()
        }
        configApplication()
        self.handlerNetworkChanged()
        
//        self.appcoordinator?.showTest()
        
        //test
//        WalletManager.shared.removeAllWallets()
//        WalletManager.shared.logoutWallet()
//        log.debug(WalletManager.shared.getAccount())

//        DBManager.shared.setupDB()

        if !WalletManager.shared.existWallet() {
            AppConfiguration.shared.appCoordinator!.showEntry()
        } else {
            SafeManager.shared.checkForOpenAPP()
        }
        

        NetworkSettingManager.shared.setup()
        if let url = launchOptions?[.url] as? URL {
            let opened = navigator.open(url)
            if !opened {
                navigator.present(url)
            }
        }
        saveNetWorkReachability()
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // URLNavigator Handler
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        
        if navigator.open(url) {
            return true
        }
        
        // URLNavigator View Controller
        if navigator.present(url, wrap: UINavigationController.self) != nil {
            return true
        }
        
        return false
    }

}

extension AppDelegate {
    func configApplication() {
        if !UserDefaults.standard.hasKey(.language) {
            if let language = NSLocale.preferredLanguages.first, language.hasPrefix("zh") {
                Localize.setCurrentLanguage("zh-Hans")
            }
            else {
                Localize.setCurrentLanguage("en")
            }
        }
        else {
            Localize.setCurrentLanguage(Defaults[.language])
        }
       
    }
    
    func handlerNetworkChanged() {
        let status = RealReachability.sharedInstance().currentReachabilityStatus()
        if status == .RealStatusNotReachable || status  == .RealStatusUnknown {
           
        }
        else {
            
        }
    }
}


