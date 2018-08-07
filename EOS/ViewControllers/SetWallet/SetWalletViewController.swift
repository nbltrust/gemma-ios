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
    
    var isUpdatePassword:Bool = false
    
	var coordinator: (SetWalletCoordinatorProtocol & SetWalletStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
    }
    
    func setupUI() {
        self.title = R.string.localizable.set_wallet_title()
        agree.setBackgroundImage(R.image.ic_checkbox(), for: .normal)
    }
    
    func setupEvent() {
        finished.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] tap in
            guard let `self` = self else { return }
            
            if self.isUpdatePassword, let password = self.fieldVIew.password.textField.text, let hint = self.fieldVIew.tipPassword.textField.text{
                self.coordinator?.updatePassword(password, hint: hint)
                self.showSuccess(message: R.string.localizable.change_password_success())
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
