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
    var data = WalletManagerModel()
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        walletManagerView.data = data
    }
    
    func setUpUI() {
        self.title = R.string.localizable.manager_wallet.key.localized()
    }

    
    override func configureObserveState() {
        
    }
}

extension WalletManagerViewController {
    @objc func wallNameClick(_ data: [String: Any]) {
        let model: WalletManagerModel = data["indicator"] as! WalletManagerModel
        self.coordinator?.pushToChangeWalletName(model: model)
    }
    
    @objc func exportPrivateKeyClick(_ data: [String: Any]) {
        self.coordinator?.pushToExportPrivateKey(self.data.address)
//        self.coordinator?.pushToBackupMnemonicVC()
    }
    
    @objc func changePasswordClick(_ data: [String: Any]) {
        self.coordinator?.pushToChangePassword(self.data.address)
    }
}
