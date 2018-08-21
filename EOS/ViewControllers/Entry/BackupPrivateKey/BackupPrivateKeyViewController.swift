//
//  BackupPrivateKeyViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BackupPrivateKeyViewController: BaseViewController {

	var coordinator: (BackupPrivateKeyCoordinatorProtocol & BackupPrivateKeyStateManagerProtocol)?
    
    var publicKey: String = WalletManager.shared.currentPubKey
    
	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.copy_priKey_title.key.localized()
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

extension BackupPrivateKeyViewController {
    @objc func know(_ data:[String:Any]) {
        self.coordinator?.showPresenterVC(publicKey)
    }
}
