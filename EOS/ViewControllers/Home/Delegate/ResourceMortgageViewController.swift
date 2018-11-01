//
//  ResourceMortgageViewController.swift
//  EOS
//
//  Created zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class ResourceMortgageViewController: BaseViewController {

	var coordinator: (ResourceMortgageCoordinatorProtocol & ResourceMortgageStateManagerProtocol)?

    @IBOutlet weak var contentView: DelegateView!
    var balance: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        coordinator?.getCurrentFromLocal()
        coordinator?.getAccountInfo(WalletManager.shared.getAccount())
    }

    func resetData() {
        self.contentView.pageView.leftView.cpuMortgageView.clearText()
        self.contentView.pageView.leftView.netMortgageView.clearText()
        self.contentView.pageView.rightView.cpuMortgageCancelView.clearText()
        self.contentView.pageView.rightView.netMortgageCancelView.clearText()
        self.contentView.nextButton.isEnabel.accept(false)
        self.coordinator?.pushToPaymentVC()
    }

    func setupUI() {
        self.title = R.string.localizable.resource_manager.key.localized()
    }

    override func configureObserveState() {

        coordinator?.state.property.info.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            self.contentView.data = model
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.cpuMoneyValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.leftView.cpuMortgageView.warningText = warning
            if warning != "" {
                self.contentView.pageView.leftView.cpuMortgageView.checkStatus = .warning
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.netMoneyValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.leftView.netMortgageView.warningText = warning
            if warning != "" {
                self.contentView.pageView.leftView.netMortgageView.checkStatus = .warning
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        Observable.combineLatest(self.coordinator!.state.property.cpuMoneyValid.asObservable(),
                                 self.coordinator!.state.property.netMoneyValid.asObservable()
            ).map { (arg0) -> Bool in

                if self.contentView.pageView.leftView.netMortgageView.textField.text == "", self.contentView.pageView.leftView.cpuMortgageView.textField.text == "" {
                    return false
                }

                if arg0.0.0 == true, self.contentView.pageView.leftView.netMortgageView.textField.text == "" {
                    return true
                } else if arg0.1.0 == true, self.contentView.pageView.leftView.cpuMortgageView.textField.text == "" {
                    return true
                }

                return arg0.0.0 && arg0.1.0
            }.bind(to: self.contentView.nextButton.isEnabel).disposed(by: disposeBag)

        coordinator?.state.property.cpuReliveMoneyValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.rightView.cpuMortgageCancelView.warningText = warning
            if warning != "" {
                self.contentView.pageView.rightView.cpuMortgageCancelView.checkStatus = .warning
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        coordinator?.state.property.netReliveMoneyValid.asObservable().subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            var warning = ""
            warning = model.1
            self.contentView.pageView.rightView.netMortgageCancelView.warningText = warning
            if warning != "" {
                self.contentView.pageView.rightView.netMortgageCancelView.checkStatus = .warning
            }
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        Observable.combineLatest(self.coordinator!.state.property.cpuReliveMoneyValid.asObservable(),
                                 self.coordinator!.state.property.netReliveMoneyValid.asObservable()
            ).map { (arg0) -> Bool in

                if self.contentView.pageView.rightView.netMortgageCancelView.textField.text == "", self.contentView.pageView.rightView.cpuMortgageCancelView.textField.text == "" {
                    return false
                }

                if arg0.0.0 == true, self.contentView.pageView.rightView.netMortgageCancelView.textField.text == "" {
                    return true
                } else if arg0.1.0 == true, self.contentView.pageView.rightView.cpuMortgageCancelView.textField.text == "" {
                    return true
                }

                return arg0.0.0 && arg0.1.0
            }.bind(to: self.contentView.nextButton.isEnabel).disposed(by: disposeBag)
    }
}

extension ResourceMortgageViewController {
    @objc func leftnext(_ data: [String: Any]) {
        if self.contentView.nextButton.isEnabel.value == false {
            return
        }
        var model = ConfirmViewModel()
        model.recever = WalletManager.shared.getAccount()
        if var cpuAmount = self.contentView.pageView.leftView.cpuMortgageView.textField.text, var netAmount = self.contentView.pageView.leftView.netMortgageView.textField.text {
            if cpuAmount == "" {
                cpuAmount = 0.0.string(digits: AppConfiguration.EOSPrecision)
            }
            if netAmount == "" {
                netAmount = 0.0.string(digits: AppConfiguration.EOSPrecision)
            }

            model.amount = (cpuAmount.toDouble()! + netAmount.toDouble()!).string
            model.remark = R.string.localizable.delegate.key.localized() +
                cpuAmount +
                R.string.localizable.eos_for_cpu.key.localized() +
                "\n    \(netAmount)"  +
                R.string.localizable.eos_for_net.key.localized()
        }
        model.buttonTitle = R.string.localizable.confirm_mortgage.key.localized()

        self.coordinator?.presentMortgageConfirmVC(data: model)
    }
    @objc func rightnext(_ data: [String: Any]) {
        if self.contentView.nextButton.isEnabel.value == false {
            return
        }
        var model = ConfirmViewModel()
        model.recever = WalletManager.shared.getAccount()
        if var cpuAmount = self.contentView.pageView.rightView.cpuMortgageCancelView.textField.text, var netAmount = self.contentView.pageView.rightView.netMortgageCancelView.textField.text {
            if cpuAmount == "" {
                cpuAmount = 0.0.string(digits: AppConfiguration.EOSPrecision)
            }
            if netAmount == "" {
                netAmount = 0.0.string(digits: AppConfiguration.EOSPrecision)
            }
            model.amount = (cpuAmount.toDouble()! + netAmount.toDouble()!).string
            model.remark = R.string.localizable.undelegate.key.localized() +
                cpuAmount +
                R.string.localizable.eos_for_cpu.key.localized() +
                "\n    \(netAmount)"  +
                R.string.localizable.eos_for_net.key.localized()
        }
        model.buttonTitle = R.string.localizable.confirm_relieve_mortgage.key.localized()

        self.coordinator?.presentMortgageConfirmVC(data: model)
    }
    @objc func cpu(_ data: [String: Any]) {
        if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView,
            let cpuMoney = cpuTextFieldView.textField.text?.toDouble(),
            let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            if cpuTextFieldView.textField.text != "" {
                cpuTextFieldView.textField.text = cpuMoney.string(digits: AppConfiguration.EOSPrecision)
            }

            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                cpuTextFieldView.checkStatus = balenceDouble >= cpuMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            self.coordinator?.cpuValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            cpuTextFieldView.textField.text = ""
            self.coordinator?.cpuValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        }
    }
    @objc func net(_ data: [String: Any]) {
        if let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView,
            let netMoney = netTextFieldView.textField.text?.toDouble(),
            let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
            if netTextFieldView.textField.text != "" {
                netTextFieldView.textField.text = netMoney.string(digits: AppConfiguration.EOSPrecision)
            }

            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                netTextFieldView.checkStatus = balenceDouble >= netMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            self.coordinator?.netValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            netTextFieldView.textField.text = ""
            self.coordinator?.cpuValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        }
    }

    @objc func cpucancel(_ data: [String: Any]) {
        if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView,
            let cpuMoney = cpuTextFieldView.textField.text?.toDouble(),
            let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            if cpuTextFieldView.textField.text != "" {
                cpuTextFieldView.textField.text = cpuMoney.string(digits: AppConfiguration.EOSPrecision)
            }

            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                cpuTextFieldView.checkStatus = balenceDouble >= cpuMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            self.coordinator?.cpuReliveValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            cpuTextFieldView.textField.text = ""
            self.coordinator?.cpuValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        }
    }
    @objc func netcancel(_ data: [String: Any]) {
        if let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView,
            let netMoney = netTextFieldView.textField.text?.toDouble(),
            let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
            if netTextFieldView.textField.text != "" {
                netTextFieldView.textField.text = netMoney.string(digits: AppConfiguration.EOSPrecision)
            }

            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble() {
                netTextFieldView.checkStatus = balenceDouble >= netMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            self.coordinator?.netReliveValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        } else if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView, let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            netTextFieldView.textField.text = ""
            self.coordinator?.cpuValidMoney(cpuTextFieldView.textField.text!, netMoney: netTextFieldView.textField.text!, blance: balance)
        }
    }
}
