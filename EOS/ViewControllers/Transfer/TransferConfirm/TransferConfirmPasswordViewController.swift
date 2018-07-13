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

    var receiver = ""
    
    var payAccount = ""
    
    var amount = ""
    
    var remark = ""
    
    @IBOutlet weak var passwordView: TransferConfirmPasswordView!
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
        self.startLoading()
        self.coordinator?.transferAccounts(passwordView.textField.text!, account: receiver, amount: amount, code: remark, callback: { [weak self](isSuccess) in
            guard let `self` = self else { return }
            if isSuccess {
                self.showSuccess(message: R.string.localizable.transfer_successed())
                self.coordinator?.finishTransfer()
            } else {
                self.showError(message: R.string.localizable.transfer_failed())
            }
            self.endLoading()
        })
    }
}

