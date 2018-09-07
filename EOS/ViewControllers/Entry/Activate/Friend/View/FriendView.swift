//
//  FriendView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/6.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import ActiveLabel

@IBDesignable
class FriendView: BaseView {
    
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
        setContentAttribute(contentLabel:memoTitleLabel, contentLabelStr: R.string.localizable.friend_activate_title.key)
        setContentAttribute(contentLabel:warningTitleLabel,contentLabelStr: R.string.localizable.activate_title_blue.key)

    }
    
    func setContentAttribute(contentLabel:BaseLabel, contentLabelStr:String) {
        var text = ""
        if contentLabel == warningTitleLabel {
            text = contentLabelStr.localizedFormat("<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>","<corn_flower_blue>","</corn_flower_blue>")
        } else {
            text = contentLabelStr.localizedFormat("<corn_flower_blue_underline>","</corn_flower_blue_underline>","<corn_flower_blue>","</corn_flower_blue>")
        }
        contentLabel.attributedText = text.set(style: StyleNames.activate.rawValue)
    }
    
    func setupSubViewEvent() {
        keyButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(Event.CopyKey.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        memoButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] touch in
            guard let `self` = self else { return }
            self.sendEventWith(Event.CopyMemo.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.FriendViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
