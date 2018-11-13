//
//  TransferConfirmPasswordView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

enum ConfirmType: String {
    case transfer
    case bltTransfer
    case mortgage
    case relieveMortgage
    case updatePwd
    case backupPrivateKey
    case backupMnemonic
    case buyRam
    case sellRam
    case voteNode
}

class TransferConfirmPasswordView: UIView {
    enum TransferEvent: String {
        case sureTransfer
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: Button!
    @IBOutlet weak var clearButton: UIButton!

    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var pwd = "" {
        didSet {
            textField.text = pwd
        }
    }

    var btnTitle = "" {
        didSet {
            nextButton.title = btnTitle
        }
    }

    var placeHolder = "" {
        didSet {
            textField.placeholder = R.string.localizable.input.key.localized() + placeHolder + R.string.localizable.password.key.localized()

        }
    }

    func setUp() {
        clearButton.isHidden = true
        setupEvent()
        textField.isSecureTextEntry = true
        updateHeight()

    }

    @IBAction func clearBtnClick(_ sender: Any) {
        textField.text = ""
    }

    func setupEvent() {
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(TransferEvent.sureTransfer.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
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
        return (lastView?.frame.origin.y)! + (lastView?.frame.size.height)!
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

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension TransferConfirmPasswordView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearButton.isHidden = true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearButton.isHidden = false

    }

}
