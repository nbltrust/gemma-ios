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

    func reloadUI() {
        data.connected = BLTWalletIO.shareInstance()?.isConnection() ?? false
        walletManagerView.data = data
    }

    override func configureObserveState() {

    }
}

extension WalletManagerViewController {
    @objc func wallNameClick(_ data: [String: Any]) {
        guard let model = data["indicator"] as? WalletManagerModel else {
            return
        }
        if model.type == .gemma {
            self.coordinator?.pushToChangeWalletName(model: model)
        } else if model.type == .bluetooth {
            self.coordinator?.pushToDetailVC(model: model)
        }
    }

    @objc func exportPrivateKeyClick(_ data: [String: Any]) {
        guard let model = data["indicator"] as? WalletManagerModel else {
            return
        }
        if model.type == .gemma {
            self.coordinator?.pushToExportPrivateKey(self.data.address)
        } else if model.type == .bluetooth {
            self.coordinator?.pushToFingerVC(model: model)
        }
    }

    @objc func changePasswordClick(_ data: [String: Any]) {
        guard let model = data["indicator"] as? WalletManagerModel else {
            return
        }
        if model.type == .gemma {
//            self.coordinator?.pushToChangePassword(self.data.address)
        }
    }

    @objc func btnClick(_ data: [String: Any]) {
        guard let model = data["indicator"] as? WalletManagerModel else {
            return
        }
        if model.connected == true {
            self.coordinator?.disConnect({ [weak self] in
                guard let `self` = self else { return }
                self.reloadUI()
            })
        } else {
            self.coordinator?.connect({ [weak self] in
                guard let `self` = self else { return }
                self.reloadUI()
            })
        }
    }
}
