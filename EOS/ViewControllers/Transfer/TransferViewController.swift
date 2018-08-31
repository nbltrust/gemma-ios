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

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var reciverLabel: UILabel!
    @IBOutlet weak var transferContentView: TransferContentView!
    @IBOutlet weak var accountTextField: UITextField!
    var coordinator: (TransferCoordinatorProtocol & TransferStateManagerProtocol)?

    enum TextChangeEvent: String {
        case walletName
    }
    
    func resetData() {
        clearData()
        self.coordinator?.pushToPaymentVC()
    }

    func clearData() {
        self.accountTextField.text = ""
        self.transferContentView.moneyTitleTextView.clearText()
        self.transferContentView.remarkTitleTextView.clearText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let name = WalletManager.shared.getAccount()
        transferContentView.setAccountName(name: name)
        getData()
        setUpUI()
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.coordinator?.fetchUserAccount()
    }
    
    func setUpUI() {
        self.title = R.string.localizable.tabbarTransfer.key.localized()

        self.accountTextField.delegate = self
        self.accountTextField.placeholder = R.string.localizable.account_name.key.localized()
        self.reciverLabel.text = R.string.localizable.receiver.key.localized()
        transferContentView.reload()
//        let info = WalletManager.shared.getAccount()
//        transferContentView.setInfo(info: <#T##String#>)
    }
    
    func getData() {
        self.coordinator?.fetchUserAccount(WalletManager.shared.getAccount())
    }

    
    override func configureObserveState() {
        self.coordinator?.state.property.balance.asObservable().subscribe(onNext: { (blance) in
            
            self.transferContentView.balance = blance!
        }, onError: nil, onCompleted: {
            
        }, onDisposed: nil).disposed(by: disposeBag)
        
        
        Observable.combineLatest(self.coordinator!.state.property.toNameValid.asObservable(),
                                 self.coordinator!.state.property.moneyValid.asObservable()
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
    
    
    @IBAction func clearBtnClick(_ sender: UIButton) {
        accountTextField.text = ""
        
    }
    
}



extension TransferViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == accountTextField {
            self.clearButton.isHidden = true
            let isValid = WalletManager.shared.isValidWalletName(textField.text!)
            if isValid == false {
                self.reciverLabel.text = R.string.localizable.name_warning.key.localized()
                self.reciverLabel.textColor = UIColor.scarlet
            } else {
                self.reciverLabel.text = R.string.localizable.receiver.key.localized()
                self.reciverLabel.textColor = UIColor.steel

            }
            
            if textField.text == nil || textField.text == "" {
                self.reciverLabel.text = R.string.localizable.receiver.key.localized()
                self.reciverLabel.textColor = UIColor.steel

            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
            self.clearButton.isHidden = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        self.sendEventWith(TextChangeEvent.walletName.rawValue, userinfo: ["content" : newText])

        return true

    }
    
}

extension TransferViewController {
    @objc func walletName(_ data: [String : Any]) {
        self.coordinator?.validName(data["content"] as! String)
    }
    @objc func sureTransfer(_ data: [String : Any]) {
        var data = ConfirmViewModel()
        data.recever = self.accountTextField.text!
        data.amount = self.transferContentView.moneyTitleTextView.textField.text!
        data.remark = self.transferContentView.remarkTitleTextView.textView.text!
        data.buttonTitle = R.string.localizable.check_transfer.key.localized()
        self.coordinator?.pushToTransferConfirmVC(data: data)
    }
    @objc func transferMoney(_ data: [String : Any]) {
        if let textfield = data["textfield"] as? UITextField,textfield.text != "" , let money = textfield.text?.toDouble() {
            textfield.text = money.string(digits: AppConfiguration.EOS_PRECISION)
            
            let balance = self.transferContentView.balance
            self.coordinator?.validMoney(money.string(digits: AppConfiguration.EOS_PRECISION), blance: balance)
        } else if let textfield = data["textfield"] as? UITextField {
            textfield.text = ""
            self.transferContentView.nextButton.isEnabel.accept(false)
        }
    }
}

