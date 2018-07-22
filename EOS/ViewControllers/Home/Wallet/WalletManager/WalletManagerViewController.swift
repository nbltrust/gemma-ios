//
//  WalletManagerViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class WalletManagerViewController: BaseViewController {

    @IBOutlet weak var walletManagerView: WalletManagerView!
    var coordinator: (WalletManagerCoordinatorProtocol & WalletManagerStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI() {
        self.title = R.string.localizable.manager_wallet()
//        walletManagerView.delegate = self
    }
    
    func commonObserveState() {
        coordinator?.subscribe(errorSubscriber) { sub in
            return sub.select { state in state.errorMessage }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
        
        coordinator?.subscribe(loadingSubscriber) { sub in
            return sub.select { state in state.isLoading }.skipRepeats({ (old, new) -> Bool in
                return false
            })
        }
    }
    
    override func configureObserveState() {
        commonObserveState()
        
    }
}

extension WalletManagerViewController {
    @objc func wallNameClick(_ data: [String: Any]) {
        self.coordinator?.pushToChangeWalletName(name: "")
    }
    
    @objc func exportPrivateKeyClick(_ data: [String: Any]) {
        self.coordinator?.pushToExportPrivateKey()
    }
    
    @objc func changePasswordClick(_ data: [String: Any]) {
        self.coordinator?.pushToChangePassword()
    }
}
