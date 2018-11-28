//
//  EntryViewController.swift
//  EOS
//
//  Created koofrank on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import NBLCommonModule
import SwiftyUserDefaults
import seed39_ios_golang
import Seed39

enum CreateWalletType: Int {
    case noWalletName = 0
    case wookong
    case EOS
    case beWalletName
}

class EntryViewController: BaseViewController {

    @IBOutlet weak var registerView: RegisterContentView!

    @IBOutlet weak var agreeButton: UIButton!

    @IBOutlet weak var creatButton: Button!

    @IBOutlet weak var protocolLabel: UILabel!

    @IBOutlet weak var agreeView: UIView!

    var createType: CreateWalletType = .noWalletName

    var hint = ""
    var currencyID: Int64?

    var coordinator: (EntryCoordinatorProtocol & EntryStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()

        self.title = R.string.localizable.create_wallet.key.localized()
        //获取公私钥
        WalletManager.shared.createPairKey()
        setupUI()
        setupEvent()
        Broadcaster.register(EntryViewController.self, observer: self)
    }

    @IBAction func agreeAction(_ sender: Any) {
        agreeButton.isSelected = !agreeButton.isSelected
        self.coordinator?.checkAgree(agreeButton.isSelected)
    }

    func setupUI() {
        switch createType {
        case .wookong:
            registerView.passwordView.isHidden = true
            registerView.passwordComfirmView.isHidden = true
            registerView.passwordPromptView.isHidden = true
            registerView.walletNameView.isHidden = true
        case .noWalletName:
            registerView.nameView.isHidden = true
            registerView.walletNameView.isHidden = true
        case .EOS:
            registerView.passwordView.isHidden = true
            registerView.passwordComfirmView.isHidden = true
            registerView.passwordPromptView.isHidden = true
            agreeView.isHidden = true
            registerView.walletNameView.isHidden = true
            self.title = R.string.localizable.create_account.key.localized()
        case .beWalletName:
            registerView.nameView.isHidden = true
            let walletName = WalletManager.shared.normalWalletName()
            registerView.walletNameView.textField.text = walletName
        }
    }

    func setupEvent() {
        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            switch self.createType {
            case .wookong:
                self.createBltWallet()
            case .noWalletName:
                if let mnemonic = Seed39NewMnemonic(), let pwd = self.registerView.passwordView.textField.text, let prompt = self.registerView.passwordPromptView.textField.text {
                    let walletName = WalletManager.shared.normalWalletName()
                    self.coordinator?.createNewWallet(walletName: walletName, pwd: pwd, checkStr: mnemonic, deviceName: nil, prompt: prompt)
                }
                self.coordinator?.pushBackupMnemonicVC()
            case .EOS:
                if let name = self.registerView.nameView.textField.text {
                    self.coordinator?.verifyAccount(name, completion: {[weak self] (success) in
                        guard let `self` = self else { return }

                        if success == true {
                            CurrencyManager.shared.saveAccountNameWith(self.currencyID, name: name)
                            self.coordinator?.pushToActivateVCWithCurrencyID(self.currencyID)
                        }
                    })
                }
            case .beWalletName:
                if let mnemonic = Seed39NewMnemonic(), let pwd = self.registerView.passwordView.textField.text, let prompt = self.registerView.passwordPromptView.textField.text {
                    if let walletName = self.registerView.walletNameView.textField.text {
                        self.coordinator?.createNewWallet(walletName: walletName, pwd: pwd, checkStr: mnemonic, deviceName: nil, prompt: prompt)
                    }
                }
                self.coordinator?.pushBackupMnemonicVC()
            }
        }).disposed(by: disposeBag)

        protocolLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.pushToServiceProtocolVC()
        }).disposed(by: disposeBag)

        self.coordinator?.state.callback.finishEOSCurrencyCallback.accept({[weak self] (code) in
            guard let `self` = self else { return }
            if let str = code as? String {
                if let name = self.registerView.nameView.textField.text {
                    self.coordinator?.createEOSAccount(.gemma, accountName: name, currencyID: self.currencyID, inviteCode: str, validation: nil, deviceName: nil, completion: { (_) in
                        self.endLoading()
                    })
                }
            }
        })
    }

    override func configureObserveState() {
        Observable.combineLatest(self.coordinator!.state.property.nameValid.asObservable(),
                                 self.coordinator!.state.property.passwordValid.asObservable(),
                                 self.coordinator!.state.property.comfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.isAgree.asObservable(),
                                 self.coordinator!.state.property.walletNameValid.asObservable()).map { [weak self] (arg0) -> Bool in
                                    guard let `self` = self else { return false }
                                    switch self.createType {
                                    case .wookong:
                                        return arg0.3
                                    case .noWalletName:
                                        return arg0.1 && arg0.2 && arg0.3
                                    case .EOS:
                                        return arg0.0
                                    case .beWalletName:
                                        return arg0.1 && arg0.2 && arg0.3 && arg0.4
                                    }
        }.bind(to: creatButton.isEnabel).disposed(by: disposeBag)
    }

    func createBltWallet() {
        if BLTWalletIO.shareInstance()?.isConnection() ?? false {
            if let nav = self.navigationController {
                connectBLTCard(nav) { [weak self] in
                    guard let `self` = self else {return}
                    self.handleBltWalletCreation()
                }
            }
        } else {
            handleBltWalletCreation()
        }
    }

    func handleBltWalletCreation() {
        self.startLoading()
        self.coordinator?.createBLTWallet(self.registerView.nameView.textField.text!, currencyID: self.currencyID, completion: { (_) in
            self.endLoading()
        })
    }
}

extension EntryViewController {
    @objc func accountName(_ data: [String: Any]) {
        guard let content = data["content"] as? String else {
            return
        }
        self.coordinator?.validAccountName(content)
    }

    @objc func walletNameEndEdit(_ data: [String: Any]) {
        guard let content = data["content"] as? String else {
            return
        }
        self.coordinator?.validWalletName(content)
    }

    @objc func walletPassword(_ data: [String: Any]) {
        guard let content = data["content"] as? String else {
            return
        }

        self.coordinator?.validPassword(content)
    }

    @objc func walletComfirmPassword(_ data: [String: Any]) {
        guard let content = data["content"] as? String else {
            return
        }
        self.coordinator?.validComfirmPassword(content, comfirmPassword: self.registerView.passwordView.textField.text!)
    }
}
