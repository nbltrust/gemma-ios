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
import eos_ios_core_cpp
import Seed39
import seed39_ios_golang

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
        loadViewIfNeeded()
        self.setTitleAndPlaceholder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setTitleAndPlaceholder() {
        self.passwordView.title = R.string.localizable.pwdview_title.key.localized()
        self.passwordView.placeHolder = R.string.localizable.pwdview_placeholder.key.localized()
        if self.context?.type == ConfirmType.backupMnemonic.rawValue {
            self.passwordView.placeHolder = R.string.localizable.mnemonic_pwdview_placeholder.key.localized()
        }
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
                    self.configLeftNavButton(R.image.ic_mask_close())
                } else {
                    self.configLeftNavButton(R.image.ic_mask_back())
                }

                if context.type == ConfirmType.updatePwd.rawValue {
                    self.passwordView.title = R.string.localizable.update_pwd_title.key.localized()
                    self.passwordView.btnTitle = R.string.localizable.update_pwd_btntitle.key.localized()
                }
            }
        }).disposed(by: disposeBag)
    }

    func transfer() {
        guard let context = context else { return }

        self.view.endEditing(true)
        self.startLoading(true)
        var infoModel: TransferInfoModel = TransferInfoModel()
        infoModel.account = context.receiver
        infoModel.pwd = passwordView.textField.text!
        infoModel.amount = context.amount
        infoModel.remark = context.remark
        self.coordinator?.transferAccounts(infoModel, assetModel: self.context?.model, callback: { [weak self] (isSuccess, message) in
            guard let `self` = self else { return }
            if isSuccess {
                self.endLoading()
                self.coordinator?.finishTransfer()
            } else {
                self.showError(message: message)
            }
        })
    }

    func bltTransfer() {
        guard let context = context else { return }

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
    }

    func mortgage() {
        guard let context = context else { return }

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
    }

    func relieveMortgage() {
        guard let context = context else { return }

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
    }

    func buyRam() {
        guard let context = context else { return }

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
    }

    func sellRam() {
        guard let context = context else { return }

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
    }

    func voteNode() {
        guard let context = context else { return }

        self.view.endEditing(true)
        self.startLoading()
        self.coordinator?.voteNode(passwordView.textField.text!,
                                   account: CurrencyManager.shared.getCurrentAccountName(),
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

extension TransferConfirmPasswordViewController {
    @objc func sureTransfer(_ data: [String: Any]) {
        guard let context = context else { return }
        var isWalletManager = false
        if let preVC = self.presentingViewController as? BaseNavigationController {
            for subVC in preVC.viewControllers {
                if subVC is WalletManagerViewController {
                    isWalletManager = true
                    break
                }
            }
        }
        if context.type != ConfirmType.bltTransfer.rawValue {
            if CurrencyManager.shared.pwdIsCorrect(context.currencyID, password: passwordView.textField.text!) == false {
                self.errCount += 1
                if self.errCount == 3 {
                    var message = WalletManager.shared.currentWallet()?.hint
                    if isWalletManager == true {
                        message = WalletManager.shared.getManagerWallet()?.hint
                    }
                    if let _ = CurrencyManager.shared.getCiperWith(context.currencyID), let message = message {
                        self.showError(message: message)
                    }
                } else {
                    self.showError(message: R.string.localizable.password_not_match.key.localized())
                }
                return
            }

            if let callback = context.callback {
                var cipher = WalletManager.shared.currentWallet()?.cipher
                if isWalletManager == true {
                    cipher = WalletManager.shared.getManagerWallet()?.cipher
                }
                if context.type == ConfirmType.backupMnemonic.rawValue, let cip = cipher {
                    if let mnemonic = Seed39KeyDecrypt(passwordView.textField.text!, cip) {
                        callback(mnemonic, self)
                        return
                    }
                }
                if context.type == ConfirmType.backupPrivateKey.rawValue, let currency = CurrencyManager.shared.getCurrencyBy(context.currencyID) {
                    var prikey = ""
                    if currency.type == .EOS {
                        prikey = EOSIO.getPirvateKey(currency.cipher, password: passwordView.textField.text!)
                    } else if currency.type == .ETH {
                        prikey = Seed39KeyDecrypt(passwordView.textField.text!, currency.cipher)
                    }
                    callback(prikey, self)
                    return
                }
            }
        }

        let myType = context.type
        if myType == ConfirmType.transfer.rawValue {
            self.transfer()
        } else if myType == ConfirmType.bltTransfer.rawValue {
            self.bltTransfer()
        } else if myType == ConfirmType.mortgage.rawValue {
            self.mortgage()
        } else if myType == ConfirmType.relieveMortgage.rawValue {
            self.relieveMortgage()
        } else if myType == ConfirmType.buyRam.rawValue {
            self.buyRam()
        } else if myType == ConfirmType.sellRam.rawValue {
            self.sellRam()
        } else if myType == ConfirmType.voteNode.rawValue {
            self.voteNode()
        }
    }
}
