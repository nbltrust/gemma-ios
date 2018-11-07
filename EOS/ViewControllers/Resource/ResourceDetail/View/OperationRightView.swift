//
//  OperationRightView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/26.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class OperationRightView: UIView {

    @IBOutlet weak var cpuMortgageCancelView: TitleTextfieldView!
    @IBOutlet weak var netMortgageCancelView: TitleTextfieldView!

    enum InputType: Int {
        case cpu = 1
        case net
    }

    enum Event: String {
        case cpucancel
        case netcancel
    }

    var data: Any? {
        didSet {
            cpuMortgageCancelView.reloadData()
            netMortgageCancelView.reloadData()
            if let data = data as? BuyRamViewModel {
                cpuMortgageCancelView.introduceLabel.text = R.string.localizable.can_use.key.localized() + data.rightTrade
            }
            updateHeight()
        }
    }

    func setUp() {
        handleSetupSubView(cpuMortgageCancelView, tag: InputType.cpu.rawValue)
        handleSetupSubView(netMortgageCancelView, tag: InputType.net.rawValue)
        updateHeight()
    }

    var isHiddenBottomView = false {
        didSet {
            netMortgageCancelView.isHidden = isHiddenBottomView
        }
    }

    func handleSetupSubView(_ titleTextfieldView: TitleTextfieldView, tag: Int) {
        titleTextfieldView.titleLabel.font = UIFont.cnTitleMedium
        titleTextfieldView.textField.font = UIFont.pfScR16
        titleTextfieldView.textField.tag = tag
        titleTextfieldView.textField.delegate = self
        titleTextfieldView.textField.keyboardType = .decimalPad
        titleTextfieldView.introduceLabel.font = UIFont.pfScR12
        titleTextfieldView.introduceLabel.textColor = UIColor.introductionColor
        titleTextfieldView.delegate = self
        titleTextfieldView.datasource = self
        titleTextfieldView.updateContentSize()
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

extension OperationRightView: TitleTextFieldViewDelegate, TitleTextFieldViewDataSource {
    func textUnitStr(titleTextFieldView: TitleTextfieldView) -> String {
        return ""
    }

    func textUISetting(titleTextFieldView: TitleTextfieldView) -> TitleTextSetting {
        if data != nil {
            if titleTextFieldView == cpuMortgageCancelView {
                if let data = data as? [OperationViewModel] {
                    return TitleTextSetting(title: data[0].title,
                                            placeholder: data[0].placeholder,
                                            warningText: data[0].warning,
                                            introduce: data[0].introduce,
                                            isShowPromptWhenEditing: data[0].isShowPromptWhenEditing,
                                            showLine: data[0].showLine,
                                            isSecureTextEntry: data[0].isSecureTextEntry)
                }
                return TitleTextSetting(title: R.string.localizable.sell_ram.key.localized(),
                                        placeholder: R.string.localizable.sell_ram_placeholder.key.localized(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: false,
                                        isSecureTextEntry: false)
            } else {
                if let data = data as? [OperationViewModel] {
                    return TitleTextSetting(title: data[1].title,
                                            placeholder: data[1].placeholder,
                                            warningText: data[1].warning,
                                            introduce: data[1].introduce,
                                            isShowPromptWhenEditing: data[1].isShowPromptWhenEditing,
                                            showLine: data[1].showLine,
                                            isSecureTextEntry: data[1].isSecureTextEntry)
                }
                return TitleTextSetting(title: R.string.localizable.sell_ram.key.localized(),
                                        placeholder: R.string.localizable.sell_ram_placeholder.key.localized(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: false,
                                        isSecureTextEntry: false)
            }
        } else {
            if titleTextFieldView == cpuMortgageCancelView {
                if isHiddenBottomView == true {
                    return TitleTextSetting(title: R.string.localizable.sell_ram.key.localized(),
                                            placeholder: R.string.localizable.sell_ram_placeholder.key.localized(),
                                            warningText: "",
                                            introduce: "",
                                            isShowPromptWhenEditing: true,
                                            showLine: true,
                                            isSecureTextEntry: false)
                } else {
                    return TitleTextSetting(title: R.string.localizable.cpu.key.localized(),
                                            placeholder: R.string.localizable.mortgage_cancel_placeholder.key.localized(),
                                            warningText: "",
                                            introduce: "",
                                            isShowPromptWhenEditing: true,
                                            showLine: true,
                                            isSecureTextEntry: false)
                }
            } else {
                return TitleTextSetting(title: R.string.localizable.net.key.localized(),
                                        placeholder: R.string.localizable.mortgage_cancel_placeholder.key.localized(),
                                        warningText: "",
                                        introduce: "",
                                        isShowPromptWhenEditing: true,
                                        showLine: false,
                                        isSecureTextEntry: false)
            }
        }
    }

    func textIntroduction(titleTextFieldView: TitleTextfieldView) {

    }

    func textActionTrigger(titleTextFieldView: TitleTextfieldView, selected: Bool, index: NSInteger) {
        titleTextFieldView.clearText()
    }

    func textActionSettings(titleTextFieldView: TitleTextfieldView) -> [TextButtonSetting] {
        return [TextButtonSetting(imageName: R.image.ic_close.name,
                                  selectedImageName: R.image.ic_close.name,
                                  isShowWhenEditing: true)]
    }
}

extension OperationRightView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            cpuMortgageCancelView.reloadActionViews(isEditing: true)
            cpuMortgageCancelView.checkStatus = TextUIStyle.highlight
        case InputType.net.rawValue:
            netMortgageCancelView.reloadActionViews(isEditing: true)
            netMortgageCancelView.checkStatus = TextUIStyle.highlight
        default:
            return
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case InputType.cpu.rawValue:
            cpuMortgageCancelView.reloadActionViews(isEditing: false)
            self.sendEventWith(Event.cpucancel.rawValue, userinfo: ["cputextfieldview": cpuMortgageCancelView, "nettextfieldview": netMortgageCancelView])
            self.sendEventWith(Event.netcancel.rawValue, userinfo: ["cputextfieldview": cpuMortgageCancelView, "nettextfieldview": netMortgageCancelView])
        case InputType.net.rawValue:
            netMortgageCancelView.reloadActionViews(isEditing: false)
            self.sendEventWith(Event.cpucancel.rawValue, userinfo: ["cputextfieldview": cpuMortgageCancelView, "nettextfieldview": netMortgageCancelView])
            self.sendEventWith(Event.netcancel.rawValue, userinfo: ["cputextfieldview": cpuMortgageCancelView, "nettextfieldview": netMortgageCancelView])

        default:
            return
        }
    }
}
