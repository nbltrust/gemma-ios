//
//  RegisterContentView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/4.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import SwifterSwift
import GrowingTextView

@IBDesignable
class RegisterContentView: UIView {

    @IBOutlet weak var nameView: TitleTextfieldView!
    @IBOutlet weak var passwordView: TitleTextfieldView!
    @IBOutlet weak var passwordComfirmView: TitleTextfieldView!
    @IBOutlet weak var passwordPromptView: TitleTextfieldView!
    @IBOutlet weak var tipsView: SharpCornerTipsLabelView!
    @IBOutlet weak var walletNameView: TitleTextfieldView!

    enum InputType: Int {
        case accountName = 1
        case password
        case comfirmPassword
        case passwordPrompt
        case walletName
    }

    enum TextChangeEvent: String {
        case accountName
        case walletPassword
        case walletComfirmPassword
        case walletNameEndEdit
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }

    func setup() {
        setupUI()
        updateContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    func updateContentSize() {
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
        self.performSelector(onMainThread: #selector(self.updateHeight), with: nil, waitUntilDone: false)
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
        tipsView.isHidden = true
        handleSetupSubView(nameView, tag: InputType.accountName.rawValue)
        handleSetupSubView(walletNameView, tag: InputType.walletName.rawValue)
        handleSetupSubView(passwordView, tag: InputType.password.rawValue)
        handleSetupSubView(passwordComfirmView, tag: InputType.comfirmPassword.rawValue)
        handleSetupSubView(passwordPromptView, tag: InputType.passwordPrompt.rawValue)
    }

    func handleSetupSubView(_ titleTextfieldView: TitleTextfieldView, tag: Int) {
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
//        titleTextfieldView.textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.pfScR14])
        titleTextfieldView.updateContentSize()
        titleTextfieldView.textField.addTarget(self, action: #selector(handleTextFiledDidChanged(_:)), for: .editingChanged)
    }

    func passwordSwitch(isSelected: Bool) {
        let tempPassword = passwordView.textField.text
        passwordView.textField.text = ""
        passwordView.textField.isSecureTextEntry = !isSelected
        passwordView.textField.text = tempPassword

        let tempComfirmPassword = passwordComfirmView.textField.text
        passwordComfirmView.textField.text = ""
        passwordComfirmView.textField.isSecureTextEntry = !isSelected
        passwordComfirmView.textField.text = tempComfirmPassword
    }

    @objc func handleTextFiledDidChanged(_ textField: UITextField) {
        handleTextField(textField)
    }
}

extension RegisterContentView: TitleTextFieldViewDelegate, TitleTextFieldViewDataSource {
    func textIntroduction(titleTextFieldView: TitleTextfieldView) {
//        if titleTextFieldView == inviteCodeView {
//            self.sendEventWith(IntroduceEvent.getInviteCode.rawValue, userinfo: [:])
//        }
    }

    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        if titleTextFieldView == passwordView {
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
            return TitleTextSetting(title: R.string.localizable.account_wallet_name.key.localized(),
                                    placeholder: R.string.localizable.name_ph.key.localized(),
                                    warningText: R.string.localizable.name_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else if titleTextFieldView == walletNameView {
            return TitleTextSetting(title: R.string.localizable.wallet_name.key.localized(),
                                    placeholder: R.string.localizable.wallet_name_ph.key.localized(),
                                    warningText: R.string.localizable.walletname_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: true,
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
        } else if titleTextFieldView == passwordComfirmView {
            return TitleTextSetting(title: R.string.localizable.account_comfirm_password.key.localized(),
                                    placeholder: R.string.localizable.comfirm_password_ph.key.localized(),
                                    warningText: R.string.localizable.comfirm_password_warning.key.localized(),
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: true)
        } else if titleTextFieldView == passwordPromptView {
            return TitleTextSetting(title: R.string.localizable.account_password_prompt.key.localized(),
                                    placeholder: R.string.localizable.password_prompt_ph.key.localized(),
                                    warningText: "",
                                    introduce: "",
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: false)
        } else {
            return TitleTextSetting(title: R.string.localizable.account_invitationcode.key.localized(),
                                    placeholder: R.string.localizable.invitationcode_ph.key.localized(),
                                    warningText: R.string.localizable.invitationcode_warning.key.localized(),
                                    introduce: R.string.localizable.invitationcode_introduce.key.localized(),
                                    isShowPromptWhenEditing: false,
                                    showLine: true,
                                    isSecureTextEntry: false)
        }
    }

    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        if titleTextFieldView == passwordView {
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

extension RegisterContentView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.accountName.rawValue:
            nameView.reloadActionViews(isEditing: true)
            if nameView.checkStatus != TextUIStyle.warning {
                nameView.checkStatus = TextUIStyle.highlight
            }
        case InputType.walletName.rawValue:
            walletNameView.reloadActionViews(isEditing: true)
            if walletNameView.checkStatus != TextUIStyle.warning {
                walletNameView.checkStatus = TextUIStyle.highlight
            }
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: true)
            if passwordView.checkStatus != TextUIStyle.warning {
                passwordView.checkStatus = TextUIStyle.highlight
            }
//            tipsView.isHidden = false
//            SwifterSwift.delay(milliseconds: 3000) {
//                self.tipsView.isHidden = true
//            }
        case InputType.comfirmPassword.rawValue:
            passwordComfirmView.reloadActionViews(isEditing: true)
            if passwordComfirmView.checkStatus != TextUIStyle.warning {
                passwordComfirmView.checkStatus = TextUIStyle.highlight
            }
        case InputType.passwordPrompt.rawValue:
            passwordPromptView.reloadActionViews(isEditing: true)
            if passwordPromptView.checkStatus != TextUIStyle.warning {
                passwordPromptView.checkStatus = TextUIStyle.highlight
            }
            passwordPromptView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.accountName.rawValue:
            nameView.reloadActionViews(isEditing: false)
            if textField.text == "" {
                nameView.checkStatus = TextUIStyle.common
            } else {
                nameView.checkStatus = WalletManager.shared.isValidAccountName(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            }
        case InputType.walletName.rawValue:
            walletNameView.reloadActionViews(isEditing: false)
            if textField.text == "" {
                walletNameView.checkStatus = TextUIStyle.common
            } else {
                walletNameView.checkStatus = WalletManager.shared.isValidWalletName(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            }
        case InputType.password.rawValue:
            passwordView.reloadActionViews(isEditing: false)
            if textField.text == "" {
                passwordView.checkStatus = TextUIStyle.common
            } else {
                passwordView.checkStatus = WalletManager.shared.isValidPassword(textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            }
        case InputType.comfirmPassword.rawValue:
            if textField.text == "" {
                passwordComfirmView.checkStatus = TextUIStyle.common
            } else {
                passwordComfirmView.checkStatus = WalletManager.shared.isValidComfirmPassword(textField.text!, comfirmPassword: passwordView.textField.text!) ? TextUIStyle.common : TextUIStyle.warning
            }
            passwordComfirmView.reloadActionViews(isEditing: false)
        case InputType.passwordPrompt.rawValue:
            passwordPromptView.reloadActionViews(isEditing: false)
            passwordPromptView.checkStatus = TextUIStyle.common
        default:
            return
        }
    }

    func handleTextField(_ textField: UITextField) {
        let text = textField.text ?? ""
        switch textField.tag {
        case InputType.accountName.rawValue:
            if text.count > 12 {
                textField.text = text.substring(from: 0, length: 12)
            }
            self.sendEventWith(TextChangeEvent.accountName.rawValue, userinfo: ["content": textField.text ?? ""])
        case InputType.walletName.rawValue:
            if text.count > 0 {
                self.sendEventWith(TextChangeEvent.walletNameEndEdit.rawValue, userinfo: ["content": textField.text ?? ""])
            }
        case InputType.password.rawValue:
            self.sendEventWith(TextChangeEvent.walletPassword.rawValue, userinfo: ["content": text])
        case InputType.comfirmPassword.rawValue:
            self.sendEventWith(TextChangeEvent.walletComfirmPassword.rawValue, userinfo: ["content": text])
        default:
            return
        }
    }

//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.2) {
//            if let titleTextView = textView.superview?.superview as? TitleTextView {
//                titleTextView.updateHeight()
//            }
//            self.updateHeight()
//        }
//    }
}
