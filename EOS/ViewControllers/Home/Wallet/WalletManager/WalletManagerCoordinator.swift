//
//  WalletManagerCoordinator.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import ReSwift
import Presentr

protocol WalletManagerCoordinatorProtocol {
    func pushToChangeWalletName(model: WalletManagerModel)
    func pushToExportPrivateKey(_ pubKey: String)
    func pushToChangePassword(_ pubKey:String)
    func pushToBackupMnemonicVC()
    func pushToDetailVC(model: WalletManagerModel)
    func pushToFingerVC(model: WalletManagerModel)
}

protocol WalletManagerStateManagerProtocol {
    var state: WalletManagerState { get }
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletManagerState>) -> Subscription<SelectedState>)?
    ) where S.StoreSubscriberStateType == SelectedState
    
    func connect()
    func disConnect()
}

class WalletManagerCoordinator: NavCoordinator {
    
    lazy var creator = WalletManagerPropertyActionCreate()
    
    var store = Store<WalletManagerState>(
        reducer: WalletManagerReducer,
        state: nil,
        middleware:[TrackingMiddleware]
    )
}

extension WalletManagerCoordinator: WalletManagerCoordinatorProtocol {
    //助记词调试代码
    func pushToBackupMnemonicVC() {
        if let vc = R.storyboard.mnemonic.backupMnemonicWordViewController() {
            let coordinator = BackupMnemonicWordCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToChangePassword(_ pubKey: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            app_coodinator.showPresenterPwd(leftIconType: .dismiss, pubKey: pubKey, type: confirmType.updatePwd.rawValue, producers: []) { priKey in
                if let vc = R.storyboard.leadIn.setWalletViewController() {
                    vc.coordinator = SetWalletCoordinator(rootVC: self.rootVC)
                    vc.settingType = .updatePas
                    self.rootVC.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func pushToExportPrivateKey(_ pubKey: String) {
        let vc = R.storyboard.entry.backupPrivateKeyViewController()!
        vc.publicKey = pubKey
        let coor = BackupPrivateKeyCoordinator(rootVC: self.rootVC)
        let currentVc = self.rootVC.topViewController!
        coor.state.callback.hadSaveCallback.accept {
            self.rootVC.popToViewController(currentVc, animated: true)
        }
        vc.coordinator = coor
        self.rootVC.pushViewController(vc, animated: true)
    }
    
    func pushToChangeWalletName(model: WalletManagerModel) {
        if let vc = R.storyboard.wallet.changeWalletNameViewController() {
            let coordinator = ChangeWalletNameCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToDetailVC(model: WalletManagerModel) {
        if let vc = R.storyboard.wallet.walletDetailViewController() {
            let coordinator = WalletDetailCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
    
    func pushToFingerVC(model: WalletManagerModel) {
        if let vc = R.storyboard.wallet.fingerViewController() {
            let coordinator = FingerCoordinator(rootVC: self.rootVC)
            vc.coordinator = coordinator
            vc.model = model
            self.rootVC.pushViewController(vc, animated: true)
        }
    }
}

extension WalletManagerCoordinator: WalletManagerStateManagerProtocol {
    var state: WalletManagerState {
        return store.state
    }
    
    func subscribe<SelectedState, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<WalletManagerState>) -> Subscription<SelectedState>)?
        ) where S.StoreSubscriberStateType == SelectedState {
        store.subscribe(subscriber, transform: transform)
    }
    
    func connect() {
        
    }
    
    func disConnect() {
        
    }
}
