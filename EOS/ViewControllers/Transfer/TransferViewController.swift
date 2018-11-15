//
//  TransferViewController.swift
//  EOS
//
//  Created DKM on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import Presentr

class TransferViewController: BaseViewController {

    @IBOutlet weak var transferContentView: TransferContentView!
    var coordinator: (TransferCoordinatorProtocol & TransferStateManagerProtocol)?
    var accountName: String = ""
    private(set) var context: TransferContext?

    func resetData() {
        clearData()
        self.coordinator?.popVC()
    }

    func clearData() {
        self.transferContentView.receiverTitleTextView.clearText()
        self.transferContentView.moneyTitleTextView.clearText()
        self.transferContentView.remarkTitleTextView.clearText()
        self.transferContentView.nextButton.isEnabel.accept(false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        setUpUI()
        getData()
        checkWalletType()
    }

	override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setUpUI() {
        self.title = R.string.localizable.tabbarTransfer.key.localized()
        if let id = CurrencyManager.shared.getCurrentCurrencyID(), let name = CurrencyManager.shared.getAccountNameWith(id) {
            accountName = name
            transferContentView.setAccountName(name: accountName)
        }
        transferContentView.reload()
        clearData()
        if let balance = self.context?.model.balance, let name = self.context?.model.name {
            self.transferContentView.balance = balance + " \(name)"
        }
    }

    func checkWalletType() {
        if WalletManager.shared.isBluetoothWallet() {
            let bltView = UIImageView(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
            bltView.contentMode = .left
            bltView.image = R.image.ic_wookong()
            transferContentView.accountTitleTextView.textField.leftView = bltView
            transferContentView.accountTitleTextView.textField.leftViewMode = .always
            return
        }
        transferContentView.accountTitleTextView.textField.leftView = UIView()
    }

    func getData() {
        self.coordinator?.fetchUserAccount(accountName)
    }

    override func configureObserveState() {
//        self.coordinator?.state.balance.asObservable().subscribe(onNext: { (blance) in
//
//            self.transferContentView.balance = blance!
//        }, onError: nil, onCompleted: {
//
//        }, onDisposed: nil).disposed(by: disposeBag)
        self.coordinator?.state.context.asObservable().subscribe(onNext: { [weak self] (context) in
            guard let `self` = self else { return }
            if let context = context as? TransferContext {
                self.context = context
                if let balance = self.context?.model.balance, let name = self.context?.model.name {
                    self.transferContentView.balance = balance + " \(name)"
                }
            }


        }).disposed(by: disposeBag)

        Observable.combineLatest(self.coordinator!.state.toNameValid.asObservable(),
                                 self.coordinator!.state.moneyValid.asObservable()
                                 ).map { (arg0) -> Bool in
                                    var warning = ""
                                    warning = arg0.1.1
                                    self.transferContentView.moneyTitleTextView.warningText = warning
                                    if warning != "" {
                                        self.transferContentView.moneyTitleTextView.checkStatus = .warning

                                    }
                                    return arg0.0 && arg0.1.0
            }.bind(to: self.transferContentView.nextButton.isEnabel).disposed(by: disposeBag)

    }
}

extension TransferViewController {
    @objc func receiverChanged(_ data: [String: Any]) {
        if let textfield = data["textfield"] as? UITextField, let name = textfield.text {
            self.coordinator?.validName(name)
        }
    }
    @objc func sureTransfer(_ data: [String: Any]) {
        var data = ConfirmViewModel()
        data.recever = self.transferContentView.receiverTitleTextView.textField.text!
        data.amount = self.transferContentView.moneyTitleTextView.textField.text!
        data.remark = self.transferContentView.remarkTitleTextView.textView.text!
        data.payAccount = self.transferContentView.accountTitleTextView.textField.text!
        data.buttonTitle = R.string.localizable.check_transfer.key.localized()
        data.symbol = self.context?.model.name ?? "EOS"
        self.coordinator?.pushToTransferConfirmVC(data: data, model: self.context?.model)
    }
    @objc func transferMoney(_ data: [String: Any]) {
        if let textfield = data["textfield"] as? UITextField, textfield.text != "", let money = textfield.text?.toDecimal() {
            textfield.text = money.string(digits: AppConfiguration.EOSPrecision)

            let balance = self.transferContentView.balance
            self.coordinator?.validMoney(money.string(digits: AppConfiguration.EOSPrecision), blance: balance)
        } else if let textfield = data["textfield"] as? UITextField {
            textfield.text = ""
            self.transferContentView.nextButton.isEnabel.accept(false)
        }
    }
}
