//
//  VerifyMnemonicWordView.swift
//  EOS
//
//  Created zhusongyu on 2018/9/13.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation
import TagListView

@IBDesignable
class VerifyMnemonicWordView: EOSBaseView {

    @IBOutlet weak var myTagListView: TagListView!

    @IBOutlet weak var poolTagListView: TagListView!

    var selectValues: [String] = []

    enum Event: String {
        case verifyMnemonicWordViewDidClicked
        case verifyMnemonicWord
    }

    override func setup() {
        super.setup()

        setupUI()
        setupSubViewEvent()
    }

    func setupUI() {
        myTagListView.delegate = self
        myTagListView.textFont = UIFont.pfScM16

        poolTagListView.delegate = self
        poolTagListView.textFont = UIFont.pfScM16
    }

    func setPoolArray(_ array: [String]) {
        poolTagListView.addTags(array)
    }

    func cleanTagListView() {
        myTagListView.removeAllTags()
    }

    func setupSubViewEvent() {

    }

    @objc override func didClicked() {
        self.next?.sendEventWith(Event.verifyMnemonicWordViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension VerifyMnemonicWordView: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == myTagListView {
            myTagListView.removeTagView(tagView)
            poolTagListView.addTag(title)
            tagView.tagBackgroundColor = UIColor.baseColor
        } else if sender == poolTagListView {
            poolTagListView.removeTagView(tagView)
            myTagListView.addTag(title)
            tagView.tagBackgroundColor = UIColor.white
            selectValues.removeAll()
            for index in 0..<myTagListView.tagViews.count {
                let view = myTagListView.tagViews[index]
                selectValues.append(view.titleLabel?.text ?? "")
            }
            self.next?.sendEventWith(Event.verifyMnemonicWord.rawValue, userinfo: ["data": selectValues])
        }
    }
}
