//
//  MnemonicContentView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/14.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import TagListView

@IBDesignable
class MnemonicContentView: EOSBaseView, TagListViewDelegate {

    @IBOutlet weak var contentTagListView: TagListView!
    @IBOutlet weak var nextButton: Button!
    @IBOutlet weak var tipsTitleLabel: BaseLabel!
    @IBOutlet weak var tipsLabel: BaseLabel!

    enum Event: String {
        case MnemonicContentViewDidClicked
        case Copied
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        contentTagListView.delegate = self
        contentTagListView.textFont = UIFont.pfScM16

        tipsTitleLabel.text = R.string.localizable.backup_mnemonic_tips_title.key.localized()
        tipsLabel.text = R.string.localizable.backup_mnemonic_tips_content.key.localized()
    }

    func setMnemonicWordArray(_ array: [String]) {
        contentTagListView.addTags(array)
    }

    func setupSubViewEvent() {
        nextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.nextButton.next?.sendEventWith(Event.Copied.rawValue, userinfo: ["data": ""])
        }).disposed(by: disposeBag)
    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.MnemonicContentViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
