//
//  InvitationView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class InvitationView: EOSBaseView {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var introLabel: BaseLabel!
    @IBOutlet weak var nextButton: Button!
    @IBOutlet weak var clearButton: UIButton!

    enum Event: String {
        case invitationViewDidClicked
        case introClick
        case nextClick
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        textfield.placeholder = R.string.localizable.invitation_code_placeholder.key.localized()
        nextButton.isEnabel.accept(false)
        clearButton.isHidden = true
    }

    @IBAction func clearBtnClick(_ sender: Any) {
        textfield.text = ""
    }

    func setupSubViewEvent() {
        introLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.introLabel.next?.sendEventWith(Event.introClick.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            if self.textfield.text == "" {
                self.nextButton.isEnabel.accept(false)
            } else {
                self.nextButton.next?.sendEventWith(Event.nextClick.rawValue, userinfo: [:])
            }
        }).disposed(by: disposeBag)
    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.invitationViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension InvitationView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.clearButton.isHidden = true
        if textField.text != "" {
            nextButton.isEnabel.accept(true)
        } else {
            nextButton.isEnabel.accept(false)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.clearButton.isHidden = false
        if textField.text != "" {
            nextButton.isEnabel.accept(true)
        } else {
            nextButton.isEnabel.accept(false)
        }
    }
}
