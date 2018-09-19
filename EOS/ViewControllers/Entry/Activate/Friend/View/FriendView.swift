//
//  FriendView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import SwiftNotificationCenter

@IBDesignable
class FriendView: EOSBaseView {
    
    @IBOutlet weak var priKeyLabel: BaseLabel!
    @IBOutlet weak var memoTitleLabel: BaseLabel!
    @IBOutlet weak var warningTitleLabel: BaseLabel!
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var memoButton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!
    
    enum Event:String {
        case FriendViewDidClicked
        case CopyKey
        case CopyMemo
    }
        
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        keyLabel.text = WalletManager.shared.priKey
        Broadcaster.notify(EntryViewController.self) { (vc) in
            let walletName = vc.registerView.nameView.textField.text!
            memoLabel.text = walletName + "-" + WalletManager.shared.currentPubKey
        }
        setContentAttribute(contentLabel:memoTitleLabel, contentLabelStr: R.string.localizable.friend_activate_title.key)
        setContentAttribute(contentLabel:warningTitleLabel,contentLabelStr: R.string.localizable.activate_title_blue.key)
    }
    
    func updateTitle(memoText: String, priKeyText: String) {
        setContentAttribute(contentLabel:memoTitleLabel, contentLabelStr: memoText)
        setContentAttribute(contentLabel:priKeyLabel, contentLabelStr: priKeyText)
    }
    
    func setContentAttribute(contentLabel:BaseLabel, contentLabelStr:String) {
        var text = ""
        if contentLabel == warningTitleLabel {
            text = contentLabelStr.localizedFormat("<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>")
            contentLabel.attributedText = text.set(style: StyleNames.activate.rawValue)
        } else if contentLabel == memoTitleLabel {
            text = contentLabelStr.localizedFormat("<corn_flower_blue_underline>","</corn_flower_blue_underline>","<corn_flower_blue>","</corn_flower_blue>")
            contentLabel.attributedText = text.set(style: StyleNames.activate.rawValue)
        } else {
            contentLabel.text = contentLabelStr
        }
    }
    
    func setupSubViewEvent() {
        keyButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.copyText(self.keyLabel.text!)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        memoButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.copyText(self.memoLabel.text!)
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.FriendViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
    
    func copyText(_ text:String) {
        let key = text
        let pasteboard = UIPasteboard.general
        pasteboard.string = key
        showSuccessTop(R.string.localizable.have_copied.key.localized())
    }
}
