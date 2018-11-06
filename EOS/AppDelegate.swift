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
import MonkeyKing
import Reachability

let log = SwiftyBeaver.self
let navigator = Navigator()
let reachability = Reachability()!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if !DEBUG
        Fabric.with([Crashlytics.self, Answers.self])
        #else
        Fabric.sharedSDK().debug = true
        #endif
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

        NotificationCenter.default.addObserver(self, selector: #selector(handlerNetworkChanged(note:)), name: .reachabilityChanged, object: reachability)
        try? reachability.startNotifier()

        configApplication()

//        self.appcoordinator?.showTest()

        //test
//        WalletManager.shared.removeAllWallets()
//        WalletManager.shared.logoutWallet()
//        log.debug(CurrencyManager.shared.getCurrentAccountName())

        DBManager.shared.setupDB()

        if !WalletManager.shared.existWallet() {
            do {
                let array = try WalletCacheService.shared.fetchAllWallet()
                if array?.count == 0 {
                    AppConfiguration.shared.appCoordinator!.showEntry()
                }
            } catch {
                AppConfiguration.shared.appCoordinator!.showEntry()
            }
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

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
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
            } else {
                Localize.setCurrentLanguage("en")
            }
        } else {
            Localize.setCurrentLanguage(Defaults[.language])
        }

    }

    @objc func handlerNetworkChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else {
            return
        }

        switch reachability.connection {
        case .none:break
        default:break
        }
    }
}
