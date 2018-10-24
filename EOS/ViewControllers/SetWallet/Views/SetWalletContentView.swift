//
//  SetWalletContentView.swift
//  EOS
//
//  Created by DKM on 2018/7/22.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class SetWalletContentView: UIView {

    enum InputType: Int {
        case name = 1
        case password
        case comfirmPassword
        case passwordPrompt
        case invitationCode
    }

    enum TextChangeEvent: String {
        case walletName
        case walletPassword
        case walletComfirmPassword
        case walletInviteCode
    }

    @IBOutlet weak var password: TitleTextfieldView!
    @IBOutlet weak var resetPassword: TitleTextfieldView!
    @IBOutlet weak var tipPassword: TitleTextfieldView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    @objc fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView!.bottom
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func setupUI() {
        handleSetupSubView(password, tag: InputType.password.rawValue)
        handleSetupSubView(resetPassword, tag: InputType.comfirmPassword.rawValue)
        handleSetupSubView(tipPassword, tag: InputType.passwordPrompt.rawValue)
        updateContentSize()
    }

    func updateContentSize() {
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
    }

    func handleSetupSubView(_ titleTextfieldView: TitleTextfieldView, tag: Int) {
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
        titleTextfieldView.updateContentSize()
        titleTextfieldView.textField.addTarget(self, action: #selector(handleTextFiledDidChanged(_:)), for: .editingChanged)
    }

    func passwordSwitch(isSelected: Bool) {
        let tempPassword = password.textField.text
        password.textField.text = ""
        password.textField.isSecureTextEntry = !isSelected
        password.textField.text = tempPassword

        let tempComfirmPassword = resetPassword.textField.text
        resetPassword.textField.text = ""
        resetPassword.textField.isSecureTextEntry = !isSelected
        resetPassword.textField.text = tempComfirmPassword
    }

    @objc func handleTextFiledDidChanged(_ textField: UITextField) {
        handleTextField(textField)
    }

}

extension SetWalletContentView: TitleTextFieldViewDelegate, TitleTextFieldViewDataSource {
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {

    }

    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        if titleTextFieldView == password {
            if index == 0 {
                titleTextFieldView.clearText()
                handleTextField(titleTextFieldView.textField)
            } else if index == 1 {
                passwordSwitch(isSelected: selected)
            }
        } else {
            if index == 0 {
                titleTextFieldView.clearText()
                handleTextField(titleTextFieldView.textField)
            }
        }
    }

    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if titleTextFieldView == password {
            return TitleTextSetting(title: R.string.localizable.account_setting_password.key.localized(),
                                    placeholder: R.string.localizable.password_ph.key.localized(),
                                    warningText: R.string.localizable.password_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextFieldView == resetPassword {
            return TitleTextSetting(title: R.string.localizable.account_comfirm_password.key.localized(),
                                    placeholder: R.string.localizable.comfirm_password_ph.key.localized(),
                                    warningText: R.string.localizable.comfirm_password_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else {
            return TitleTextSetting(title: R.string.localizable.account_password_prompt.key.localized(),
                                    placeholder: R.string.localizable.password_prompt_ph.key.localized(),
                                    warningText: "",
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: false,
                                    isSecureTextEntry: false)
        }
    }

    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        if titleTextFieldView == password {
            return [TextButtonSetting(imageName: R.image.ic_close.name,
                                      selectedImageName: R.image.ic_close.name,
                                      isShowWhenEditing: true),
                    TextButtonSetting(imageName: R.image.ic_visible.name,
                                      selectedImageName: R.image.ic_invisible.name,
                                      isShowWhenEditing: false)]
        } else {
            return [TextButtonSetting(imageName: R.image.ic_close.name,
                                      selectedImageName: R.image.ic_close.name,
                                      isShowWhenEditing: true)]
        }
    }

    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }
}

extension SetWalletContentView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.password.rawValue:
            password.reloadActionViews(isEditing: true)
            password.checkStatus = TextUIStyle.highlight
        case InputType.comfirmPassword.rawValue:
            resetPassword.reloadActionViews(isEditing: true)
            resetPassword.checkStatus = TextUIStyle.highlight
        case InputType.passwordPrompt.rawValue:
            tipPassword.reloadActionViews(isEditing: true)
            tipPassword.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {

        case InputType.password.rawValue:
            password.reloadActionViews(isEditing: false)
            password.checkStatus = WalletManager.shared.isValidPassword(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            resetPassword.checkStatus = WalletManager.shared.isValidComfirmPassword(textField.text!, comfirmPassword: resetPassword.textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.comfirmPassword.rawValue:
            resetPassword.reloadActionViews(isEditing: false)
            resetPassword.checkStatus = WalletManager.shared.isValidComfirmPassword(textField.text!, comfirmPassword: password.textField.text!) ? TextUIStyle.common : TextUIStyle.warning
        case InputType.passwordPrompt.rawValue:
            tipPassword.reloadActionViews(isEditing: false)
            tipPassword.checkStatus = TextUIStyle.common
        default:
            return
        }
    }

    func handleTextField(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField.tag {
        case InputType.name.rawValue:
            self.sendEventWith(TextChangeEvent.walletName.rawValue, userinfo: ["content": text])
        case InputType.password.rawValue:
            self.sendEventWith(TextChangeEvent.walletPassword.rawValue, userinfo: ["content": text])
        case InputType.comfirmPassword.rawValue:
            self.sendEventWith(TextChangeEvent.walletComfirmPassword.rawValue, userinfo: ["content": text])
        default:
            return
        }
    }
}
