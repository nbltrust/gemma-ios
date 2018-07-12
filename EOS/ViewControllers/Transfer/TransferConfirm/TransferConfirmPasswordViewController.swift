//
//  TransferConfirmPasswordViewController.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class TransferConfirmPasswordViewController: BaseViewController {

	var coordinator: (TransferConfirmPasswordCoordinatorProtocol & TransferConfirmPasswordStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        configLeftNavButton(R.image.icBack())
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

extension TransferConfirmPasswordViewController {
    @objc func sureTransfer(_ data: [String : Any]) {
        self.coordinator?.pushToPaymentsVC()
    }
}

