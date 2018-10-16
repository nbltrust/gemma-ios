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
    
    func setUpUI() {
        self.title = R.string.localizable.manager_wallet.key.localized()
        walletManagerView.data = data
    }
    
    func checkBLTState() {
        data.connected = BLTWalletIO.shareInstance()?.isConnection() ?? false
        self.coordinator?.getFPList({ [weak self] (fpList) in
            guard let `self` = self else { return }
            self.data.fingerprinted = fpList?.count ?? 0 > 0
        }, failed: { [weak self] (reason) in
            guard let `self` = self else { return }
            if let failedReason = reason {
                self.showError(message: failedReason)
            }
        })
    }

    
    override func configureObserveState() {
        
    }
}

extension WalletManagerViewController {
    @objc func wallNameClick(_ data: [String: Any]) {
        let model: WalletManagerModel = data["indicator"] as! WalletManagerModel
        if model.type == .gemma {
            self.coordinator?.pushToChangeWalletName(model: model)
        } else if model.type == .bluetooth {
            self.coordinator?.pushToDetailVC(model: model)
        }
    }
    
    @objc func exportPrivateKeyClick(_ data: [String: Any]) {
        let model: WalletManagerModel = data["indicator"] as! WalletManagerModel
        if model.type == .gemma {
            self.coordinator?.pushToExportPrivateKey(self.data.address)
        } else if model.type == .bluetooth {
            self.coordinator?.pushToChangePassword(self.data.address)
        }
    }
    
    @objc func changePasswordClick(_ data: [String: Any]) {
        let model: WalletManagerModel = data["indicator"] as! WalletManagerModel
        if model.type == .gemma {
            self.coordinator?.pushToChangePassword(self.data.address)
        } else if model.type == .bluetooth {
            if model.fingerprinted == true {
                self.coordinator?.pushToFingerVC(model: model)
            } else {
                self.coordinator?.pushToFingerVC(model: model)
            }
        }
    }
    
    @objc func btnClick(_ data: [String: Any]) {
        let model: WalletManagerModel = data["data"] as! WalletManagerModel
        if model.connected == true {
            self.coordinator?.disConnect()
        } else {
            self.coordinator?.connect()
        }
    }
}
