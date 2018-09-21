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
        self.coordinator?.getValidation({ [weak self] (sn, sn_sig, pub, pub_sig) in
            guard let `self` = self else { return }
            var validation = WookongValidation()
            validation.SN = sn ?? ""
            validation.SN_sig = sn_sig ?? ""
            validation.public_key = pub ?? ""
            validation.public_key_sig = pub_sig ?? ""
            self.coordinator?.createWallet(.bluetooth, accountName: self.registerView.nameView.textField.text!, password: "", prompt: "", inviteCode: "", validation: validation, completion: { (successed) in
                self.coordinator?.pushToPrinterSetView()
            })
        }, failed: { [weak self] (reason) in
            guard let `self` = self else { return }
            if let failedReason = reason {
                self.showError(message: failedReason)
            }
        })
    }
    
    func setupEvent() {
        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            switch self.createType {
            case .wookong:
                self.coordinator?.copyMnemonicWord()
            default:
                self.coordinator?.verifyAccount(self.registerView.nameView.textField.text!, completion: { (success) in
                    if success == true {
                        self.coordinator?.pushToActivateVC()
                    }
                })
            }
//            self.coordinator?.createWallet(self.registerView.nameView.textField.text!, password: self.registerView.passwordView.textField.text!, prompt: self.registerView.passwordPromptView.textField.text!, inviteCode: self.registerView.inviteCodeView.textField.text!, completion: { (success) in
//                
//            })
        }).disposed(by: disposeBag)
        
        protocolLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.pushToServiceProtocolVC()
        }).disposed(by: disposeBag)
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
}

extension EntryViewController {
    @objc func walletName(_ data: [String : Any]) {
        self.coordinator?.validWalletName(data["content"] as! String)
    }
    
    @objc func walletPassword(_ data: [String : Any]) {
        self.coordinator?.validPassword(data["content"] as! String)
    }
    
    @objc func walletComfirmPassword(_ data: [String : Any]) {
        self.coordinator?.validComfirmPassword(data["content"] as! String, comfirmPassword: self.registerView.passwordView.textField.text!)
    }
}
