//
//  FriendView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import NBLCommonModule

@IBDesignable
class FriendView: EOSBaseView {

    @IBOutlet weak var memoTitleLabel: BaseLabel!
    @IBOutlet weak var warningTitleLabel: BaseLabel!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!

    enum Event: String {
        case friendViewDidClicked
        case copyKey
        case copyMemo
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        memoLabel.text = CurrencyManager.shared.getCurrentAccountName() + "-" + CurrencyManager.shared.currentPublicKey()
        setContentAttribute(contentLabel: memoTitleLabel, contentLabelStr: R.string.localizable.friend_activate_title.key)
        setContentAttribute(contentLabel: warningTitleLabel, contentLabelStr: R.string.localizable.activate_title_blue.key)
    }

    func updateTitle(memoText: String, priKeyText: String) {
        setContentAttribute(contentLabel: memoTitleLabel, contentLabelStr: memoText)
    }

    func setContentAttribute(contentLabel: BaseLabel, contentLabelStr: String) {
        var text = ""
        if contentLabel == warningTitleLabel {
            text = contentLabelStr.localizedFormat("<corn_flower_blue>",
                                                   "</corn_flower_blue>",
                                                   "<corn_flower_blue>",
                                                   "</corn_flower_blue>",
                                                   "<corn_flower_blue>",
                                                   "</corn_flower_blue>",
                                                   "<corn_flower_blue>",
                                                   "</corn_flower_blue>")
            contentLabel.attributedText = text.set(style: StyleNames.activate.rawValue)
        } else if contentLabel == memoTitleLabel {
            text = contentLabelStr.localizedFormat("<corn_flower_blue_underline>", "</corn_flower_blue_underline>", "<corn_flower_blue>", "</corn_flower_blue>")
            contentLabel.attributedText = text.set(style: StyleNames.activate.rawValue)
        } else {
            contentLabel.text = contentLabelStr
        }
    }

    func setupSubViewEvent() {
        memoButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            copyText(self.memoLabel.text!)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.friendViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
