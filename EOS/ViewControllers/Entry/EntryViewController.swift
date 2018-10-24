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

enum CreateWalletType: Int {
    case normal = 0
    case wookong
}

class EntryViewController: BaseViewController {

    @IBOutlet weak var registerView: RegisterContentView!

    @IBOutlet weak var agreeButton: UIButton!

    @IBOutlet weak var creatButton: Button!

    @IBOutlet weak var protocolLabel: UILabel!

    var createType: CreateWalletType = .normal

    var hint = ""

    var coordinator: (EntryCoordinatorProtocol & EntryStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()

        self.title = R.string.localizable.create_wallet.key.localized()
        //获取公私钥
        WalletManager.shared.createPairKey()
        setupUI()
        setupEvent()
        Broadcaster.register(EntryViewController.self, observer: self)

        NotificationCenter.default.addObserver(self, selector: #selector(createWookongWallet), name: NSNotification.Name(rawValue: "createBLTWallet"), object: nil)
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
            registerView.nameView.gapView.isHidden = true
        default:
            return
        }
    }

    @objc func createWookongWallet() {
        self.coordinator?.checkSeedSuccessed()
    }

    func setupEvent() {
        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            switch self.createType {
            case .wookong:
                if (self.coordinator?.state.property.checkSeedSuccessed.value ?? false)! {
                    self.createBltWallet()
                } else {
                    self.coordinator?.copyMnemonicWord()
                }
            default:
                self.coordinator?.verifyAccount(self.registerView.nameView.textField.text!, completion: { (success) in
                    if success == true {
                        self.coordinator?.pushToActivateVC()
                    }
                })
            }
        }).disposed(by: disposeBag)

        protocolLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.coordinator?.pushToServiceProtocolVC()
        }).disposed(by: disposeBag)

        self.coordinator?.state.callback.finishBLTWalletCallback.accept({
            self.coordinator?.checkSeedSuccessed()
            self.createBltWallet()
        })
    }

    override func configureObserveState() {
        Observable.combineLatest(self.coordinator!.state.property.nameValid.asObservable(),
                                 self.coordinator!.state.property.passwordValid.asObservable(),
                                 self.coordinator!.state.property.comfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.isAgree.asObservable()).map { [weak self] (arg0) -> Bool in
                                    guard let `self` = self else { return false }
                                    switch self.createType {
                                    case .wookong:
                                        return arg0.0 && arg0.3
                                    default:
                                        return arg0.0 && arg0.1 && arg0.2 && arg0.3
                                    }
        }.bind(to: creatButton.isEnabel).disposed(by: disposeBag)
    }

    func createBltWallet() {
        self.startLoading()
        self.coordinator?.createWallet(self.registerView.nameView.textField.text!, completion: { (_) in
            self.endLoading()
        })
    }
}

extension EntryViewController {
    @objc func walletName(_ data: [String: Any]) {
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
