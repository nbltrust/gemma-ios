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
import SwiftRichString

class EntryViewController: BaseViewController {
    
    @IBOutlet weak var registerView: RegisterContentView!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    @IBOutlet weak var agreeLabel: UILabel!
    
    @IBOutlet weak var creatButton: Button!
    
	var coordinator: (EntryCoordinatorProtocol & EntryStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
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
    
    @IBAction func agreeAction(_ sender: Any) {
        agreeButton.isSelected = !agreeButton.isSelected
    }
    
    func setupUI() {
        let agreeStyle: Style = Styles.styles[StyleNames.agree.rawValue] as! Style
        let agreementStyle: Style = Styles.styles[StyleNames.agreement.rawValue] as! Style
        let agreeGroup = StyleGroup(base: agreeStyle, [StyleNames.agreement.rawValue : agreementStyle])
        let str = String(format: "%@  <%@>%@</%@>",R.string.localizable.agree_title(),StyleNames.agreement.rawValue, R.string.localizable.service_protocol(),StyleNames.agreement.rawValue)
        agreeLabel.attributedText = str.set(style: agreeGroup)
    }
    
    func setupEvent() {
        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            self.coordinator?.createWallet(self.registerView.nameView.textField.text!, password: self.registerView.passwordView.textField.text!, prompt: self.registerView.passwordPromptView.textField.text!, inviteCode: self.registerView.inviteCodeView.textField.text!, completion: {[weak self] (success) in
            })
        }).disposed(by: disposeBag)
    }
    
    override func configureObserveState() {
        commonObserveState()
        
        
        self.coordinator?.state.property.nameValid.subscribe(onNext: {[weak self] (valid) in
            guard let `self` = self else { return }
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        self.coordinator?.state.property.passwordValid.subscribe(onNext: {[weak self] (valid) in
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        
        
        Observable.combineLatest(self.coordinator!.state.property.nameValid.asObservable(),
                                 self.coordinator!.state.property.passwordValid.asObservable(),
                                 self.coordinator!.state.property.comfirmPasswordValid.asObservable(),
                                 self.coordinator!.state.property.inviteCodeValid.asObservable()).map { (arg0) -> Bool in
                                    log.debug(arg0)
            return arg0.0 && arg0.1 && arg0.2 && arg0.3
        }.bind(to: creatButton.button.rx.isEnabled).disposed(by: disposeBag)
        
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
    
    @objc func walletInviteCode(_ data: [String : Any]) {
        self.coordinator?.validWalletName(data["content"] as! String)
    }
}
