//
//  SetWalletViewController.swift
//  EOS
//
//  Created DKM on 2018/7/20.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import NBLCommonModule

enum WalletSettingType: Int {
    case leadInWithPriKey = 0
    case leadInWithMnemonic
    case updatePas
    case wookong
    case updatePin
}

class SetWalletViewController: BaseViewController {

    @IBOutlet weak var agree: UIButton!
    @IBOutlet weak var servers: UILabel!
    @IBOutlet weak var finished: Button!
    @IBOutlet weak var fieldView: SetWalletContentView!
    @IBOutlet weak var agreeView: UIView!

    var wallet: Wallet!

    var priKey: String = ""

    var mnemonicStr: String = ""

    var currencyType: CurrencyType = .EOS

    var settingType: WalletSettingType = .leadInWithPriKey

	var coordinator: (SetWalletCoordinatorProtocol & SetWalletStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }

    func setupUI() {
        fieldView.settingType = settingType
        switch settingType {
        case .leadInWithPriKey:
            setupWithLeadIn()
        case .leadInWithMnemonic:
            setupWithLeadIn()
        case .updatePas:
            setupWithPas()
        case .wookong:
            setupWithWookong()
        case .updatePin:
            setupWithPin()
        }
        agree.setBackgroundImage(R.image.ic_checkbox(), for: .normal)
    }

    func setupWithPin() {
        self.title = R.string.localizable.change_password.key.localized()
        fieldView.nameView.isHidden = true

        let pas = R.string.localizable.new_password.key.localized()
        fieldView.passwordView.setting.title = pas
        fieldView.passwordView.titleLabel.text = pas
        finished.title = R.string.localizable.update_pwd_btn_title.key.localized()
        agreeView.isHidden = true
    }

    func setupWithPas() {
        self.title = R.string.localizable.change_password.key.localized()
        fieldView.isChangePassword = true

        let originTitle = R.string.localizable.original_password.key.localized()
        fieldView.nameView.setting.title = originTitle
        fieldView.nameView.titleLabel.text = originTitle

        let originPh = R.string.localizable.original_password_ph.key.localized()
        fieldView.nameView.setting.placeholder = originPh
        fieldView.nameView.textField.placeholder = originPh

        let pas = R.string.localizable.new_password.key.localized()
        fieldView.passwordView.setting.title = pas
        fieldView.passwordView.titleLabel.text = pas
        finished.title = R.string.localizable.update_pwd_btn_title.key.localized()
        agreeView.isHidden = true
    }

    func setupWithWookong() {
        self.title = R.string.localizable.wookong_title.key.localized()

        let pasSetTitle = R.string.localizable.wookong_pas_set_title.key.localized()
        fieldView.passwordView.setting.title = pasSetTitle
        fieldView.passwordView.titleLabel.text = pasSetTitle

        finished.title = R.string.localizable.next_step.key.localized()
        fieldView.nameView.isHidden = true
        agreeView.isHidden = false
    }

    func setupWithLeadIn() {
        self.title = R.string.localizable.set_wallet_title.key.localized()
        agreeView.isHidden = false
    }

    func importWallet() {
        if let name = self.fieldView.nameView.textField.text,
            let password = self.fieldView.passwordView.textField.text,
            let hint = self.fieldView.hintView.textField.text {
            self.coordinator?.importPriKeyWallet(name,
                                                 priKey: priKey,
                                                 type: currencyType,
                                                 password: password,
                                                 hint: hint,
                                                 success: { [weak self] in
                guard let `self` = self else { return }
                self.coordinator?.importFinished()
            }, failed: {[weak self] (reason) in
                guard let `self` = self else { return }
                if let failedReson = reason {
                    self.showError(message: failedReson)
                }
            })
        }
    }

    func setupEvent() {
        finished.button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            if self.finished.isEnabel.value == true {
                switch self.settingType {
                case .leadInWithPriKey:
                    self.importWallet()
                case .leadInWithMnemonic:
                    self.importWallet()
                case .updatePas:
                    if let password = self.fieldView.passwordView.textField.text,
                        let hint = self.fieldView.hintView.textField.text {
                        self.coordinator?.updatePassword(password, hint: hint)
                        self.showSuccess(message: R.string.localizable.change_password_success.key.localized())
                    }
                case .wookong:
                    if let password = self.fieldView.passwordView.textField.text {
                        self.coordinator?.setWalletPin(password, success: { [weak self] in
                            guard let `self` = self else { return }
                            self.coordinator?.pushToMnemonicVC()
                        }, failed: { [weak self] (reason) in
                            guard let `self` = self else { return }
                            if let failedReason = reason {
                                self.showError(message: failedReason)
                            }
                        })
                    }
                case .updatePin:
                    if let password = self.fieldView.passwordView.textField.text {
                        self.coordinator?.updatePin(password, success: { [weak self] in
                            guard let `self` = self else { return }
                            self.coordinator?.popVC()
                            self.showSuccess(message: R.string.localizable.change_password_success.key.localized())
                        }, failed: { [weak self] (reason) in
                            guard let `self` = self else { return }
                            if let failedReason = reason {
                                self.showError(message: failedReason)
                            }
                        })
                    }
                }
            }
        }).disposed(by: disposeBag)

        servers.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.pushToServiceProtocolVC()
        }).disposed(by: disposeBag)
    }

    @IBAction func clickAgree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected == true ?sender.setBackgroundImage(R.image.icCheckboxAbled(), for: .normal) :
        sender.setBackgroundImage(R.image.ic_checkbox(), for: .normal)
        self.coordinator?.checkAgree(sender.isSelected)
    }

    override func configureObserveState() {
        Observable.combineLatest(self.coordinator!.state.property.setWalletNameValid.asObservable(),
                                 self.coordinator!.state.property.setWalletPasswordValid.asObservable(),
                                 self.coordinator!.state.property.setWalletComfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.setWalletIsAgree.asObservable(),
                                 self.coordinator!.state.property.setWalletOriginalPasswordValid.asObservable()).map { (arg0) -> Bool in
                                    if self.settingType == .leadInWithMnemonic || self.settingType == .leadInWithPriKey {
                                        return arg0.0 && arg0.1 && arg0.2 && arg0.3
                                    } else if self.settingType == .updatePas {
                                        return arg0.1 && arg0.2 && arg0.4
                                    } else if self.settingType == .updatePin {
                                        return arg0.1 && arg0.2
                                    }
                                    return arg0.1 && arg0.2 && arg0.3
            }.bind(to: finished.isEnabel).disposed(by: disposeBag)

        self.coordinator?.state.callback.finishBLTWalletCallback.accept({
            self.coordinator?.createWookongBioWallet(self.fieldView.hintView.textField.text ?? "", success: {
                self.coordinator?.dismissNav()
            }, failed: { (reason) in
                if let failedReason = reason {
                    showFailTop(failedReason)
                }
            })
        })
    }
}

extension SetWalletViewController {

    @objc func walletName(_ data: [String: Any]) {
        self.coordinator?.validName((data["valid"] as? Bool) ?? false)
    }

    @objc func walletOriginalPassword(_ data: [String: Any]) {
        self.coordinator?.validOraginalPassword((data["valid"] as? Bool) ?? false)
    }

    @objc func walletPassword(_ data: [String: Any]) {
        self.coordinator?.validPassword((data["valid"] as? Bool) ?? false)
    }

    @objc func walletComfirmPassword(_ data: [String: Any]) {
        self.coordinator?.validComfirmPassword((data["valid"] as? Bool) ?? false)
    }
}
