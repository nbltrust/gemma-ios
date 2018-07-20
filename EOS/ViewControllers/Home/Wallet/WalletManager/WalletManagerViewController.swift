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
        walletManagerView.delegate = self
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

extension WalletManagerViewController:WalletManagerViewDelegate {
    func walletNameLabelTap(walletName: UILabel) {
        self.coordinator?.pushToChangeWalletName(name: "")
    }
    
    func exportPrivateKeyLineViewTap(exportPrivateKey: LineView) {
        self.coordinator?.pushToExportPrivateKey()
    }
    
    func changePasswordLineViewTap(changePassword: LineView) {
        self.coordinator?.pushToChangePassword()
    }
    
    
}
