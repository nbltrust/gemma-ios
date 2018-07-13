//
//  TransferConfirmViewController.swift
//  EOS
//
//  Created 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import Presentr

class TransferConfirmViewController: BaseViewController {

    @IBOutlet var transferConfirmView: TransferConfirmView!
    var coordinator: (TransferConfirmCoordinatorProtocol & TransferConfirmStateManagerProtocol)?

    var toAccount = ""
    var money = ""
    var remark = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configLeftNavButton(R.image.icTransferClose())
        
        setUpUI()
    }

    func setUpUI() {
        self.transferConfirmView.recever = "@" + toAccount
        self.transferConfirmView.amount = money + " EOS"
        self.transferConfirmView.remark = remark
        self.transferConfirmView.payAccount = WallketManager.shared.getAccount()

    }
    
    override func leftAction(_ sender: UIButton) {
        self.coordinator?.dismissConfirmVC()
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

extension TransferConfirmViewController {
    @objc func sureTransfer(_ data: [String : Any]) {
        self.coordinator?.pushToTransferConfirmPwdVC(toAccount: toAccount, money: money, remark: self.transferConfirmView.remark)
    }
}
