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

    var data: ConfirmViewModel = ConfirmViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configLeftNavButton(R.image.icTransferClose())
        
        setUpUI()
    }

    func setUpUI() {
        self.transferConfirmView.data = data
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
        let type: String = data["btntitle"] as! String
        if type == R.string.localizable.check_transfer() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.transfer.rawValue)
        } else if type == R.string.localizable.confirm_mortgage() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.mortgage.rawValue)
        } else if type == R.string.localizable.confirm_relieve_mortgage() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.relieveMortgage.rawValue)
        } else if type == R.string.localizable.confirm_buy() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.buyRam.rawValue)
        } else if type == R.string.localizable.confirm_sell() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.sellRam.rawValue)
        }
    }
}
