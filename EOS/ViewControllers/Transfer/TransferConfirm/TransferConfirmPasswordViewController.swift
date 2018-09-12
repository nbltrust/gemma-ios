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

enum leftIconType: String {
    case dismiss
    case pop
}

class TransferConfirmPasswordViewController: BaseViewController {

	var coordinator: (TransferConfirmPasswordCoordinatorProtocol & TransferConfirmPasswordStateManagerProtocol)?

    var receiver = ""
    
    var amount = ""
    
    var remark = ""
    
    var type = ""
    
    var iconType = ""
    
    var producers: [String] = []
    
    var callback: StringCallback?
    
    var publicKey = WalletManager.shared.currentPubKey
    
    @IBOutlet weak var passwordView: TransferConfirmPasswordView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
        
//        log.debug(String(reflecting: type(of: a!)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        if self.iconType == leftIconType.dismiss.rawValue {
            configLeftNavButton(R.image.icTransferClose())
        } else {
            configLeftNavButton(R.image.icBack())
        }
        
        if type == confirmType.updatePwd.rawValue {
            passwordView.title = R.string.localizable.update_pwd_title.key.localized()
            passwordView.btnTitle = R.string.localizable.update_pwd_btntitle.key.localized()
        }
    }
    
    override func leftAction(_ sender: UIButton) {
        if self.iconType == leftIconType.dismiss.rawValue {
            self.coordinator?.dismissConfirmPwdVC()
        } else {
            self.passwordView.textField.resignFirstResponder()
            self.coordinator?.popConfirmPwdVC()
        }
    }

    override func configureObserveState() {
        
    }
}

extension TransferConfirmPasswordViewController {
    @objc func sureTransfer(_ data: [String : Any]) {
        guard let priKey = WalletManager.shared.getCachedPriKey(publicKey, password: passwordView.textField.text!) else {
            self.showError(message: R.string.localizable.password_not_match.key.localized())
            return
        }
        
        if let callback = self.callback {
            if self.type != confirmType.voteNode.rawValue {
                callback(priKey)
                return
            }
        }
        
        let myType = self.type
        if myType == confirmType.transfer.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.transferAccounts(passwordView.textField.text!, account: receiver, amount: amount, remark: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishTransfer()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == confirmType.mortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.mortgage(passwordView.textField.text!, account: receiver, amount: amount, remark: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })

        } else if myType == confirmType.relieveMortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.relieveMortgage(passwordView.textField.text!, account: receiver, amount: amount, remark: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == confirmType.buyRam.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.buyRam(passwordView.textField.text!, account: receiver, amount: amount, remark: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishBuyRam()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == confirmType.sellRam.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.sellRam(passwordView.textField.text!, account: receiver, amount: amount, remark: remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishBuyRam()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == confirmType.voteNode.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.voteNode(passwordView.textField.text!, account: WalletManager.shared.getAccount(), amount: amount, remark: remark, producers: producers, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.showSuccess(message: message)
                    self.coordinator?.finishVoteNode()
                } else {
                    self.showError(message: message)
                }
            })
        }

    }
}

