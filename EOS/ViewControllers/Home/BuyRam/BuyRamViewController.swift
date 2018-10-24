//
//  BuyRamViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class BuyRamViewController: BaseViewController {

    @IBOutlet weak var contentView: BuyRamView!

    var coordinator: (BuyRamCoordinatorProtocol & BuyRamStateManagerProtocol)?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = R.string.localizable.buy_ram_title.key.localized()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.coordinator?.getCurrentFromLocal()
        coordinator?.getAccountInfo(WalletManager.shared.getAccount())
    }

    func resetData() {
        self.contentView.pageView.leftView.cpuMortgageView.clearText()
        self.contentView.pageView.rightView.cpuMortgageCancelView.clearText()
        self.contentView.leftNextButton.isEnabel.accept(false)
        self.contentView.rightNextButton.isEnabel.accept(false)
        self.coordinator?.pushToPaymentVC()
    }

    override func configureObserveState() {
        coordinator?.state.property.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.contentView.data = model
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.buyRamValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.leftView.cpuMortgageView.warningText = warning
            if warning != "" {
                self.contentView.pageView.leftView.cpuMortgageView.checkStatus = .warning
            }
            self.contentView.leftNextButton.isEnabel.accept(model.0)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.sellRamValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.rightView.cpuMortgageCancelView.warningText = warning
            if warning != "" {
                self.contentView.pageView.rightView.cpuMortgageCancelView.checkStatus = .warning
            }
            self.contentView.rightNextButton.isEnabel.accept(model.0)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
}

extension BuyRamViewController {
    @objc func leftnext(_ data: [String: Any]) {
        if self.contentView.leftNextButton.isEnabel.value == false {
            return
        }
        var model = ConfirmViewModel()
        if var cpuAmount = self.contentView.pageView.leftView.cpuMortgageView.textField.text {
            if cpuAmount == "" {
                cpuAmount = 0.0.string(digits: AppConfiguration.EOS_PRECISION)
            }

            model.amount = cpuAmount
            model.remark = R.string.localizable.buy_ram_remark.key.localized()
        }
        model.buttonTitle = R.string.localizable.confirm_buy.key.localized()

        self.coordinator?.presentMortgageConfirmVC(data: model)
    }
    @objc func rightnext(_ data: [String: Any]) {
        if self.contentView.rightNextButton.isEnabel.value == false {
            return
        }
        var model = ConfirmViewModel()
        if var cpuAmount = self.contentView.pageView.rightView.cpuMortgageCancelView.textField.text {
            if cpuAmount == "" {
                cpuAmount = 0.0.string(digits: AppConfiguration.EOS_PRECISION)
            }
            model.amount = cpuAmount.toDouble()!.string
            model.remark = R.string.localizable.sell_ram_remark.key.localized()
        }
        model.buttonTitle = R.string.localizable.confirm_sell.key.localized()

        self.coordinator?.presentMortgageConfirmVC(data: model)
    }
    @objc func cpu(_ data: [String: Any]) {
        if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let cpuMoney = cpuTextFieldView.textField.text?.toDouble() {
            if cpuTextFieldView.textField.text != "" {
                cpuTextFieldView.textField.text = cpuMoney.string(digits: AppConfiguration.EOS_PRECISION)
            }
            if var balance = self.contentView.pageView.leftView.cpuMortgageView.introduceLabel.text, balance != "" {
                balance = balance.components(separatedBy: "：")[1]

                if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                    cpuTextFieldView.checkStatus = balenceDouble >= cpuMoney  ? TextUIStyle.common : TextUIStyle.warning
                }
                self.coordinator?.exchangeCalculate(cpuTextFieldView.textField.text!, type: .left)
                self.coordinator?.buyRamValid(cpuTextFieldView.textField.text!, blance: balance)
            }
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
            cpuTextFieldView.textField.text = ""
            self.coordinator?.exchangeCalculate(cpuTextFieldView.textField.text!, type: .left)
            self.contentView.leftNextButton.isEnabel.accept(false)
        }
    }

    @objc func cpucancel(_ data: [String: Any]) {
        if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let cpuMoney = cpuTextFieldView.textField.text?.toDouble() {
            if cpuTextFieldView.textField.text != "" {
                cpuTextFieldView.textField.text = cpuMoney.string(digits: AppConfiguration.EOS_PRECISION)
            }
            if var balance = self.contentView.pageView.rightView.cpuMortgageCancelView.introduceLabel.text, balance != "" {
                balance = balance.components(separatedBy: "：")[1]
                if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                    cpuTextFieldView.checkStatus = balenceDouble >= cpuMoney  ? TextUIStyle.common : TextUIStyle.warning
                }
                self.coordinator?.exchangeCalculate(cpuTextFieldView.textField.text!, type: .right)
                self.coordinator?.sellRamValid(cpuTextFieldView.textField.text!, blance: balance)
            }
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
            cpuTextFieldView.textField.text = ""
            self.contentView.rightNextButton.isEnabel.accept(false)
        }
    }

    @objc func left(_ data: [String: Any]) {
        self.coordinator?.exchangeCalculate(contentView.pageView.leftView.cpuMortgageView.textField.text!, type: .left)
    }
    @objc func right(_ data: [String: Any]) {
        self.coordinator?.exchangeCalculate(contentView.pageView.rightView.cpuMortgageCancelView.textField.text!, type: .right)
    }
}
