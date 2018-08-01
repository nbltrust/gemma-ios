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
    
    var amount = ""
    
    var remark = ""
    
    var type = ""
    
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
        let myType = self.type
        if myType == confirmType.transfer.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.transferAccounts(passwordView.textField.text!, account: receiver, amount: amount, code: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.showSuccess(message: message)
                    self.coordinator?.finishTransfer()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == confirmType.mortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.mortgage(passwordView.textField.text!, account: receiver, amount: amount, code: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.showSuccess(message: message)
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })

        } else if myType == confirmType.relieveMortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.relieveMortgage(passwordView.textField.text!, account: receiver, amount: amount, code: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.showSuccess(message: message)
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })
        }

    }
}

