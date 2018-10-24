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

enum LeftIconType: String {
    case dismiss
    case pop
}

class TransferConfirmPasswordViewController: BaseViewController {

	var coordinator: (TransferConfirmPasswordCoordinatorProtocol & TransferConfirmPasswordStateManagerProtocol)?

    var errCount = 0

    private(set) var context: TransferConfirmPasswordContext?

    @IBOutlet weak var passwordView: TransferConfirmPasswordView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()

//        log.debug(String(reflecting: type(of: a!)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func leftAction(_ sender: UIButton) {
        guard let context = context else { return }

        if context.iconType == LeftIconType.dismiss.rawValue {
            self.coordinator?.dismissConfirmPwdVC()
        } else {
            self.passwordView.textField.resignFirstResponder()
            self.coordinator?.popConfirmPwdVC()
        }
    }

    override func configureObserveState() {
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }

            if let context = context as? TransferConfirmPasswordContext {
                self.context = context

                if context.iconType == LeftIconType.dismiss.rawValue {
                    self.configLeftNavButton(R.image.icTransferClose())
                } else {
                    self.configLeftNavButton(R.image.icBack())
                }

                if context.type == ConfirmType.updatePwd.rawValue {
                    self.passwordView.title = R.string.localizable.update_pwd_title.key.localized()
                    self.passwordView.btnTitle = R.string.localizable.update_pwd_btntitle.key.localized()
                }
            }
        }).disposed(by: disposeBag)

    }
}

extension TransferConfirmPasswordViewController {
    @objc func sureTransfer(_ data: [String: Any]) {
        guard let context = context else { return }

        if context.type != ConfirmType.bltTransfer.rawValue {
            guard let priKey = WalletManager.shared.getCachedPriKey(context.publicKey, password: passwordView.textField.text!) else {
                self.errCount += 1
                if self.errCount == 3 {
                    if let message = WalletManager.shared.getPasswordHint(context.publicKey) {
                        self.showError(message: message)
                    }
                } else {
                    self.showError(message: R.string.localizable.password_not_match.key.localized())
                }
                return
            }

            if let callback = context.callback {
                if context.type != ConfirmType.voteNode.rawValue {
                    callback(priKey, self)
                    return
                }
            }
        }

        let myType = context.type
        if myType == ConfirmType.transfer.rawValue {
            self.view.endEditing(true)
            self.startLoading(true)
            self.coordinator?.transferAccounts(passwordView.textField.text!, account: context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishTransfer()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == ConfirmType.bltTransfer.rawValue {
            self.view.endEditing(true)
            self.startLoading(true)
            self.coordinator?.bltTransferAccounts(passwordView.textField.text!,
                                                  account: context.receiver,
                                                  amount: context.amount,
                                                  remark: context.remark,
                                                  callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishTransfer()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == ConfirmType.mortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.mortgage(passwordView.textField.text!, account: context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })

        } else if myType == ConfirmType.relieveMortgage.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.relieveMortgage(passwordView.textField.text!, account: context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishMortgage()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == ConfirmType.buyRam.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.buyRam(passwordView.textField.text!, account: context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishBuyRam()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == ConfirmType.sellRam.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.sellRam(passwordView.textField.text!, account: context.receiver, amount: context.amount, remark: context.remark, callback: { [weak self] (isSuccess, message) in
                guard let `self` = self else { return }
                if isSuccess {
                    self.endLoading()
                    self.coordinator?.finishBuyRam()
                } else {
                    self.showError(message: message)
                }
            })
        } else if myType == ConfirmType.voteNode.rawValue {
            self.view.endEditing(true)
            self.startLoading()
            self.coordinator?.voteNode(passwordView.textField.text!,
                                       account: WalletManager.shared.getAccount(),
                                       amount: context.amount,
                                       remark: context.remark,
                                       producers: context.producers,
                                       callback: { [weak self] (isSuccess, message) in
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
