//
//  TransferContentView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/11.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import GrowingTextView

@IBDesignable

class TransferContentView: UIView {

    @IBOutlet weak var cornerView: UIView!
    @IBOutlet weak var receiverTitleTextView: TitleTextfieldView!
    @IBOutlet weak var accountTitleTextView: TitleTextfieldView!
    @IBOutlet weak var moneyTitleTextView: TitleTextfieldView!
    @IBOutlet weak var remarkTitleTextView: TitleTextView!
    @IBOutlet weak var nextButton: Button!

    enum TransferEvent: String {
        case sureTransfer
    }

    var balance = "0 EOS" {
        didSet {
            self.moneyTitleTextView.introduceLabel.text = R.string.localizable.balance_pre.key.localized() + balance

        }
    }

    enum InputType: Int {
        case receiver = 1
        case account
        case money
        case remark
    }

    enum TextChangeEvent: String {
        case receiverChanged
        case transferAccount
        case transferMoney
        case walletRemark
    }

    func handleSetupSubView(_ titleTextfieldView: TitleTextfieldView, tag: Int) {
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
        titleTextfieldView.updateContentSize()
    }

    func setupEvent() {
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(TransferEvent.sureTransfer.rawValue, userinfo: [ : ])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func reload() {
        receiverTitleTextView.reloadData()
        accountTitleTextView.reloadData()
        moneyTitleTextView.reloadData()
        remarkTitleTextView.reloadData()

        receiverTitleTextView.reloadActionViews(isEditing: false)
        accountTitleTextView.reloadActionViews(isEditing: false)
        moneyTitleTextView.reloadActionViews(isEditing: false)
        remarkTitleTextView.reloadActionViews(isEditing: false)

        receiverTitleTextView.checkStatus = TextUIStyle.common
        accountTitleTextView.checkStatus = TextUIStyle.common
        moneyTitleTextView.checkStatus = TextUIStyle.common
        remarkTitleTextView.checkStatus = TextUIStyle.common

    }

    func setUp() {
        handleSetupSubView(receiverTitleTextView, tag: InputType.receiver.rawValue)
        handleSetupSubView(accountTitleTextView, tag: InputType.account.rawValue)
        accountTitleTextView.textField.isUserInteractionEnabled = false
        handleSetupSubView(moneyTitleTextView, tag: InputType.money.rawValue)
        remarkTitleTextView.delegate = self
        remarkTitleTextView.datasource = self
        remarkTitleTextView.textView.delegate = self
        remarkTitleTextView.textView.maxHeight = 80
        remarkTitleTextView.textView.font = UIFont.pfScS16
        nextButton.title = R.string.localizable.next_step.key.localized()
        moneyTitleTextView.introduceLabel.text = R.string.localizable.balance_pre.key.localized() + "0.0000 EOS"
        moneyTitleTextView.textField.keyboardType = UIKeyboardType.decimalPad
//        remarkTitleTextView.gapView.isHidden = true
        remarkTitleTextView.updateHeight()

        receiverTitleTextView.titleLabel.font = UIFont.cnTipMedium
        receiverTitleTextView.textField.font = UIFont.pfScS16
        receiverTitleTextView.introduceLabel.font = UIFont.pfScR12
        receiverTitleTextView.introduceLabel.textColor = UIColor.introductionColor
        accountTitleTextView.titleLabel.font = UIFont.cnTipMedium
        accountTitleTextView.textField.font = UIFont.pfScS16
        moneyTitleTextView.titleLabel.font = UIFont.cnTipMedium
        moneyTitleTextView.textField.font = UIFont.pfScS16
        moneyTitleTextView.introduceLabel.font = UIFont.pfScR12
        moneyTitleTextView.introduceLabel.textColor = UIColor.introductionColor
        updateHeight()
        remarkTitleTextView.updateHeight()
        setupEvent()
    }

    func setAccountName(name: String) {
        accountTitleTextView.textField.text = name
    }

    func setInfo(info: String) {
        accountTitleTextView.introduceLabel.text = info
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView?.bottom ?? 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setUp()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

//        self.insertSubview(view, at: 0)

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}

extension TransferContentView: TitleTextFieldViewDelegate, TitleTextFieldViewDataSource {
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {

    }

    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        return [TextButtonSetting(imageName: R.image.ic_close.name,
                                  selectedImageName: R.image.ic_close.name,
                                  isShowWhenEditing: true)]
    }

    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        titleTextFieldView.clearText()

    }

    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if titleTextFieldView == receiverTitleTextView {
            return TitleTextSetting(title: R.string.localizable.receiver.key.localized(),
                                    placeholder: R.string.localizable.account_name.key.localized(),
                                    warningText: R.string.localizable.name_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextFieldView == accountTitleTextView {
            return TitleTextSetting(title: R.string.localizable.payment_account.key.localized(),
                                    placeholder: R.string.localizable.name_ph.key.localized(),
                                    warningText: R.string.localizable.name_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextFieldView == moneyTitleTextView {
            return TitleTextSetting(title: R.string.localizable.money.key.localized(),
                                    placeholder: R.string.localizable.input_transfer_money.key.localized(),
                                    warningText: R.string.localizable.big_money.key.localized(), //文案未提供
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else {
            return TitleTextSetting(title: R.string.localizable.remark.key.localized(),
                                    placeholder: R.string.localizable.input_transfer_remark.key.localized(),
                                    warningText: "", //文案未提供
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        }
    }

    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }
}

extension TransferContentView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.receiver.rawValue:
            receiverTitleTextView.reloadActionViews(isEditing: true)
            receiverTitleTextView.checkStatus = TextUIStyle.highlight
        case InputType.account.rawValue:
            accountTitleTextView.reloadActionViews(isEditing: true)
            accountTitleTextView.checkStatus = TextUIStyle.highlight
        case InputType.money.rawValue:
            moneyTitleTextView.reloadActionViews(isEditing: true)
            moneyTitleTextView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.receiver.rawValue:
            receiverTitleTextView.reloadActionViews(isEditing: false)
            if let text = textField.text, text != "" {
                receiverTitleTextView.checkStatus = WalletManager.shared.isTransferValidWalletName(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            }
            self.sendEventWith(TextChangeEvent.receiverChanged.rawValue, userinfo: ["textfield": textField])
        case InputType.account.rawValue:
            accountTitleTextView.reloadActionViews(isEditing: false)
            accountTitleTextView.checkStatus = WalletManager.shared.isTransferValidWalletName(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.money.rawValue:
            moneyTitleTextView.reloadActionViews(isEditing: false)

            if let balenceDouble = balance.components(separatedBy: " ")[0].toDecimal(), let moneyDouble = moneyTitleTextView.textField.text?.toDecimal() {
                moneyTitleTextView.checkStatus = balenceDouble >= moneyDouble  ? TextUIStyle.common : TextUIStyle.warning
                nextButton.isEnabel.accept(balenceDouble >= moneyDouble ? true : false)
            }
            self.sendEventWith(TextChangeEvent.transferMoney.rawValue, userinfo: ["textfield": textField])
        default:
            return
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case InputType.account.rawValue:
            self.sendEventWith(TextChangeEvent.transferAccount.rawValue, userinfo: ["content": newText])
//        case InputType.money.rawValue:
//            self.sendEventWith(TextChangeEvent.transferMoney.rawValue, userinfo: ["content" : newText])

        default:
            return true
        }
        return true
    }

}

extension TransferContentView: GrowingTextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let titleTextView = textView.superview?.superview as? TitleTextView {
            titleTextView.reloadActionViews(isEditing: true)
        }
    }

    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            if let titleTextView = textView.superview?.superview as? TitleTextView {
                titleTextView.updateHeight()
            }
            self.updateHeight()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let titleTextView = textView.superview?.superview as? TitleTextView {
            titleTextView.reloadActionViews(isEditing: false)
        }
    }
}

extension TransferContentView: TitleTextViewDelegate, TitleTextViewDataSource {
    func textIntroduction(titleTextView: TitleTextView) {

    }

    func textActionSettings(titleTextView: TitleTextView) -> [TextButtonSetting] {
        return [TextButtonSetting(imageName: R.image.ic_close.name,
                                  selectedImageName: R.image.ic_close.name,
                                  isShowWhenEditing: true)]
    }

    func textActionTrigger(titleTextView: TitleTextView, selected: Bool, index: NSInteger) {
        titleTextView.clearText()

    }

    func textUISetting(titleTextView: TitleTextView) -> TitleTextSetting {
        return TitleTextSetting(title: R.string.localizable.remark.key.localized(),
                                placeholder: R.string.localizable.input_transfer_remark.key.localized(),
                                warningText: R.string.localizable.name_warning.key.localized(),
                                introduce: "",
                                isShowPromptWhenEditing: true,
                                showLine: true,
                                isSecureTextEntry: false)

    }

    func textUnitStr(titleTextView: TitleTextView) -> String {
        return ""
    }
}
