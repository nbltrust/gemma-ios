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

    
    override func configureObserveState() {
        
    }
}

extension TransferConfirmViewController {
    @objc func sureTransfer(_ data: [String : Any]) {
        let type: String = data["btntitle"] as! String
        if type == R.string.localizable.check_transfer.key.localized() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.transfer.rawValue)
        } else if type == R.string.localizable.confirm_mortgage.key.localized() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.mortgage.rawValue)
        } else if type == R.string.localizable.confirm_relieve_mortgage.key.localized() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.relieveMortgage.rawValue)
        } else if type == R.string.localizable.confirm_buy.key.localized() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.buyRam.rawValue)
        } else if type == R.string.localizable.confirm_sell.key.localized() {
            self.coordinator?.pushToTransferConfirmPwdVC(toAccount: self.data.recever, money: self.data.amount, remark: self.data.remark, type: confirmType.sellRam.rawValue)
        }
    }
}
