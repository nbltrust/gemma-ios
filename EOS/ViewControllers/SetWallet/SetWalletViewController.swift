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
import SwiftNotificationCenter

class SetWalletViewController: BaseViewController {
    
    @IBOutlet weak var agree: UIButton!
    @IBOutlet weak var servers: UILabel!
    @IBOutlet weak var finished: Button!
    @IBOutlet weak var fieldVIew: SetWalletContentView!
    @IBOutlet weak var cornerShadowView: CornerAndShadowView!
    @IBOutlet weak var agreeView: UIView!
    
    var isUpdatePassword:Bool = false
    
	var coordinator: (SetWalletCoordinatorProtocol & SetWalletStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        cornerShadowView.updateContentSize()
        setupEvent()
    }
    
    func setupUI() {
        if isUpdatePassword == true {
            self.title = R.string.localizable.change_password.key.localized()
            fieldVIew.password.setting.title = R.string.localizable.new_password.key.localized()
            fieldVIew.password.titleLabel.text = R.string.localizable.new_password.key.localized()
            finished.title = R.string.localizable.update_pwd_btn_title.key.localized()
            agreeView.isHidden = true
        } else {
            self.title = R.string.localizable.set_wallet_title.key.localized()
            agreeView.isHidden = false
        }
        agree.setBackgroundImage(R.image.ic_checkbox(), for: .normal)
    }
    
    func setupEvent() {
        finished.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.validPassword(self.fieldVIew.password.textField.text!)
            self.coordinator?.validComfirmPassword(self.fieldVIew.resetPassword.textField.text!, comfirmPassword: self.fieldVIew.password.textField.text!)
            if self.finished.isEnabel.value == true {
                if self.isUpdatePassword, let password = self.fieldVIew.password.textField.text, let hint = self.fieldVIew.tipPassword.textField.text{
                    self.coordinator?.updatePassword(password, hint: hint)
                    self.showSuccess(message: R.string.localizable.change_password_success.key.localized())
                    return
                }
                
                if let password = self.fieldVIew.password.textField.text, let hint = self.fieldVIew.tipPassword.textField.text {
                    
                    self.coordinator?.importLocalWallet(password, hint: hint, completion: {[weak self] (success) in
                        guard let `self` = self else { return }
                        if success {
                            self.coordinator?.importFinished()
                        }
                        else {
                        }
                    })
                }
            }
        }).disposed(by: disposeBag)
        
        servers.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.pushToServiceProtocolVC()
        }).disposed(by: disposeBag)
    }

    @IBAction func clickAgree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isSelected == true ?sender.setBackgroundImage(R.image.ic_checkbox_active(), for: .normal) :
        sender.setBackgroundImage(R.image.ic_checkbox(), for: .normal)
        self.coordinator?.checkAgree(sender.isSelected)
    }

    override func configureObserveState() {
        Observable.combineLatest(self.coordinator!.state.property.setWalletPasswordValid.asObservable(),
                                 self.coordinator!.state.property.setWalletComfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.setWalletIsAgree.asObservable()).map { (arg0) -> Bool in
                                    if self.isUpdatePassword {
                                        return arg0.0 && arg0.1
                                    }
                                    return arg0.0 && arg0.1 && arg0.2
            }.bind(to: finished.isEnabel).disposed(by: disposeBag)
    }
}

extension SetWalletViewController {
    @objc func walletPassword(_ data: [String : Any]) {
        self.coordinator?.validPassword(self.fieldVIew.password.textField.text!)
        self.coordinator?.validComfirmPassword(self.fieldVIew.password.textField.text!, comfirmPassword: self.fieldVIew.resetPassword.textField.text!)
    }
    
    @objc func walletComfirmPassword(_ data: [String : Any]) {
        self.coordinator?.validComfirmPassword(self.fieldVIew.resetPassword.textField.text!, comfirmPassword: self.fieldVIew.password.textField.text!)
    }
}
