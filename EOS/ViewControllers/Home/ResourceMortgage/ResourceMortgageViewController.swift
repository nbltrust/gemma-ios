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

    @IBOutlet weak var contentView: ResourceMortgageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        coordinator?.getAccountInfo(WallketManager.shared.getAccount())
    }
    
    func resetData() {
        self.contentView.pageView.leftView.cpuMortgageView.clearText()
        self.contentView.pageView.leftView.netMortgageView.clearText()
        self.contentView.pageView.rightView.cpuMortgageCancelView.clearText()
        self.contentView.pageView.rightView.netMortgageCancelView.clearText()
        self.coordinator?.pushToPaymentVC()
    }
    
    func setupUI() {
        self.title = R.string.localizable.resource_manager()

        let general = [GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.5),GeneralViewModel(name: R.string.localizable.cpu(), eos: "0.100 EOS", leftSub: "已用0.100ms", rightSub: "总量10.29ms", lineHidden: false, progress: 0.8)]

        let page = PageViewModel(balance: "0.01 EOS", leftText: R.string.localizable.mortgage_resource(), rightText: R.string.localizable.cancel_mortgage(), operationLeft: [OperationViewModel(title: R.string.localizable.mortgage_cpu(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.mortgage_net(), placeholder: R.string.localizable.mortgage_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)], operationRight: [OperationViewModel(title: R.string.localizable.cpu(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: true, isSecureTextEntry: false),OperationViewModel(title: R.string.localizable.net(), placeholder: R.string.localizable.mortgage_cancel_placeholder(), warning: "", introduce: "", isShowPromptWhenEditing: true, showLine: false, isSecureTextEntry: false)])
        contentView.data = ResourceViewModel(general: general, page: page)
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
                
                    return arg0.0.0 && arg0.1.0
            }.bind(to: self.contentView.leftNextButton.isEnabel).disposed(by: disposeBag)
    }
}

extension ResourceMortgageViewController {
    @objc func leftnext(_ data: [String:Any]) {
        
        var model = ConfirmViewModel()
        model.recever = WallketManager.shared.getAccount()
        if let cpuAmount = self.contentView.pageView.leftView.cpuMortgageView.textField.text, let netAmount = self.contentView.pageView.leftView.cpuMortgageView.textField.text {
            model.amount = (cpuAmount.toDouble()! + netAmount.toDouble()!).string
            model.remark = R.string.localizable.delegate() + cpuAmount + R.string.localizable.eos_for_cpu() + "\n    \(netAmount)"  + R.string.localizable.eos_for_net()
        }
        model.buttonTitle = R.string.localizable.confirm_mortgage()
        
        self.coordinator?.presentMortgageConfirmVC(data: model)
    }
    @objc func rightnext(_ data: [String:Any]) {
        var model = ConfirmViewModel()
        model.recever = WallketManager.shared.getAccount()
        model.amount = "123"
        model.remark = "sxsxsdw\nxsxsoxmo"
        
        model.buttonTitle = R.string.localizable.confirm_relieve_mortgage()
        self.coordinator?.presentMortgageConfirmVC(data: model)
        
    }
    @objc func cpu(_ data: [String:Any]) {
        if let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView,cpuTextFieldView.textField.text != "" , let cpuMoney = cpuTextFieldView.textField.text?.toDouble(),let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView {
            cpuTextFieldView.textField.text = cpuMoney.string(digits: AppConfiguration.EOS_PRECISION)
            let balance = self.contentView.pageView.balance
            
            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble(){
                cpuTextFieldView.checkStatus = balenceDouble > cpuMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            if let netMoney = netTextFieldView.textField.text?.toDouble() {
                self.coordinator?.cpuValidMoney(cpuMoney.string(digits: AppConfiguration.EOS_PRECISION), netMoney: netMoney.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
            } else {
                self.coordinator?.cpuValidMoney(cpuMoney.string(digits: AppConfiguration.EOS_PRECISION), netMoney: 0.0.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
            }
        }
    }
    @objc func net(_ data: [String:Any]) {
        if let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView,netTextFieldView.textField.text != "" , let netMoney = netTextFieldView.textField.text?.toDouble(),let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
            netTextFieldView.textField.text = netMoney.string(digits: AppConfiguration.EOS_PRECISION)
            let balance = self.contentView.pageView.balance
            
            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble(){
                netTextFieldView.checkStatus = balenceDouble > netMoney  ? TextUIStyle.common : TextUIStyle.warning
            }
            if let cpuMoney = cpuTextFieldView.textField.text?.toDouble() {
                self.coordinator?.netValidMoney(cpuMoney.string(digits: AppConfiguration.EOS_PRECISION), netMoney: netMoney.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
            } else {
                self.coordinator?.netValidMoney(0.0.string(digits: AppConfiguration.EOS_PRECISION), netMoney: netMoney.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
            }
        }
    }
//    @objc func netcancel(_ data: [String:Any]) {
//        if let netTextFieldView = data["nettextfieldview"] as? TitleTextfieldView,netTextFieldView.textField.text != "" , let netMoney = netTextFieldView.textField.text?.toDouble(),let cpuTextFieldView = data["cputextfieldview"] as? TitleTextfieldView {
//            netTextFieldView.textField.text = netMoney.string(digits: AppConfiguration.EOS_PRECISION)
//            let balance = self.contentView.cpuView.eos
//            
//            if let balenceDouble = balance.components(separatedBy: " ")[0].toDouble(){
//                netTextFieldView.checkStatus = balenceDouble > netMoney  ? TextUIStyle.common : TextUIStyle.warning
//            }
//            if let cpuMoney = cpuTextFieldView.textField.text?.toDouble() {
//                self.coordinator?.netValidMoney(cpuMoney.string(digits: AppConfiguration.EOS_PRECISION), netMoney: netMoney.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
//            } else {
//                self.coordinator?.netValidMoney(0.0.string(digits: AppConfiguration.EOS_PRECISION), netMoney: netMoney.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
//            }
//        }
//    }
}


