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
    }

    enum TextVaildEvent: String {
        case walletName
        case walletOriginalPassword
        case walletPassword
        case walletComfirmPassword
    }

    @IBOutlet weak var nameView: TitleTextfieldView!

    @IBOutlet weak var passwordView: TitleTextfieldView!

    @IBOutlet weak var confirmPasswordView: TitleTextfieldView!

    @IBOutlet weak var hintView: TitleTextfieldView!

    var settingType: WalletSettingType = .leadInWithPriKey {
        didSet {
            isChangePassword = (settingType == .updatePas || settingType == .updatePin)
        }
    }

    var isChangePassword: Bool = false {
        didSet {
            if isChangePassword {
                nameView.textField.text = ""
                nameView.textField.isSecureTextEntry = true
                nameView.reloadData()
                passwordView.reloadData()
            }
        }
    }

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
        handleSetupSubView(nameView, tag: InputType.name.rawValue)
        handleSetupSubView(passwordView, tag: InputType.password.rawValue)
        handleSetupSubView(confirmPasswordView, tag: InputType.comfirmPassword.rawValue)
        handleSetupSubView(hintView, tag: InputType.passwordPrompt.rawValue)
        updateContentSize()
    }

    func setWalletName() {
        if !isChangePassword {
            nameView.textField.text = WalletManager.shared.normalWalletName()
        }
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
        let selector = #selector(handleTextFiledDidChanged(_:))
        titleTextfieldView.textField.addTarget(self, action: selector, for: .editingChanged)
    }

    func passwordSwitch(isSelected: Bool) {
        if isChangePassword {
            let tempPassword = nameView.textField.text
            nameView.textField.text = ""
            nameView.textField.isSecureTextEntry = !isSelected
            nameView.textField.text = tempPassword
        }

        let tempPassword = passwordView.textField.text
        passwordView.textField.text = ""
        passwordView.textField.isSecureTextEntry = !isSelected
        passwordView.textField.text = tempPassword

        let tempComfirmPassword = confirmPasswordView.textField.text
        confirmPasswordView.textField.text = ""
        confirmPasswordView.textField.isSecureTextEntry = !isSelected
        confirmPasswordView.textField.text = tempComfirmPassword
    }

    func pasValid() -> Bool {
        let pas = passwordView.textField.text ?? ""
        let passwordValid = WalletManager.shared.isValidPassword(pas)
        return passwordValid
    }

    func originalPasValid() -> Bool {
        let pas = nameView.textField.text ?? ""
        let passwordValid = WalletManager.shared.isValidPassword(pas)
        return passwordValid
    }

    func confirmValid() -> Bool {
        let pas = passwordView.textField.text ?? ""
        let confirmPas = confirmPasswordView.textField.text ?? ""
        let confirmValid = WalletManager.shared.isValidComfirmPassword(pas, comfirmPassword: confirmPas)
        return confirmValid
    }

    func nameValid() -> Bool {
        let name = nameView.textField.text ?? ""
        return !name.isEmpty
    }

    func isShowEye(_ field: TitleTextfieldView) -> Bool {
        return (field == passwordView && !isChangePassword) || (field == nameView && isChangePassword)
    }

    @objc func handleTextFiledDidChanged(_ textField: UITextField) {
        handleTextField(textField)
    }

}

extension SetWalletContentView: TitleTextFieldViewDelegate, TitleTextFieldViewDataSource {
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {

    }

    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        if isShowEye(titleTextFieldView) {
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
        if titleTextFieldView == nameView {
            return TitleTextSetting(title: R.string.localizable.wallet_name.key.localized(),
                                    placeholder: R.string.localizable.wallet_name_pla.key.localized(),
                                    warningText: "",
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextFieldView == passwordView {
            return TitleTextSetting(title: R.string.localizable.account_setting_password.key.localized(),
                                    placeholder: R.string.localizable.password_ph.key.localized(),
                                    warningText: R.string.localizable.password_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextFieldView == confirmPasswordView {
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
                                    showLine: true,
                                    isSecureTextEntry: false)
        }
    }

    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        if isShowEye(titleTextFieldView) {
            return [TextButtonSetting(imageName: R.image.icClean.name,
                                      selectedImageName: R.image.icClean.name,
                                      isShowWhenEditing: true),
                    TextButtonSetting(imageName: R.image.ic_visible.name,
                                      selectedImageName: R.image.ic_invisible.name,
                                      isShowWhenEditing: false)]
        } else {
            return [TextButtonSetting(imageName: R.image.icClean.name,
                                      selectedImageName: R.image.icClean.name,
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
        case InputType.name.rawValue:
            nameView.reloadActionViews(isEditing: true)
            nameView.checkStatus = TextUIStyle.highlight
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: true)
            passwordView.checkStatus = TextUIStyle.highlight
        case InputType.comfirmPassword.rawValue:
            confirmPasswordView.reloadActionViews(isEditing: true)
            confirmPasswordView.checkStatus = TextUIStyle.highlight
        case InputType.passwordPrompt.rawValue:
            hintView.reloadActionViews(isEditing: true)
            hintView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.name.rawValue:
            nameView.reloadActionViews(isEditing: false)
            nameView.checkStatus = TextUIStyle.common
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: false)
            passwordView.checkStatus = pasValid() ? TextUIStyle.common : TextUIStyle.warning
            confirmPasswordView.checkStatus = confirmValid() ? TextUIStyle.common : TextUIStyle.warning
        case InputType.comfirmPassword.rawValue:
            confirmPasswordView.reloadActionViews(isEditing: false)
            confirmPasswordView.checkStatus = confirmValid() ? TextUIStyle.common : TextUIStyle.warning
        case InputType.passwordPrompt.rawValue:
            hintView.reloadActionViews(isEditing: false)
            hintView.checkStatus = TextUIStyle.common
        default:
            return
        }
    }

    func handleTextField(_ textField: UITextField) {
        switch textField.tag {
        case InputType.name.rawValue:
            if isChangePassword {
                self.sendEventWith(TextVaildEvent.walletOriginalPassword.rawValue, userinfo: ["valid": originalPasValid()])
            } else {
                self.sendEventWith(TextVaildEvent.walletName.rawValue, userinfo: ["valid": nameValid()])
            }
        case InputType.password.rawValue:
            self.sendEventWith(TextVaildEvent.walletPassword.rawValue, userinfo: ["valid": pasValid()])
            self.sendEventWith(TextVaildEvent.walletComfirmPassword.rawValue, userinfo: ["valid": confirmValid()])
        case InputType.comfirmPassword.rawValue:
            self.sendEventWith(TextVaildEvent.walletPassword.rawValue, userinfo: ["valid": pasValid()])
            self.sendEventWith(TextVaildEvent.walletComfirmPassword.rawValue, userinfo: ["valid": confirmValid()])
        default:
            return
        }
    }
}
