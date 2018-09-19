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
class VerifyMnemonicWordView: BaseView {
    
    @IBOutlet weak var myTagListView: TagListView!
    
    @IBOutlet weak var poolTagListView: TagListView!
    
    var selectValues: [String] = []
    
    enum Event:String {
        case VerifyMnemonicWordViewDidClicked
        case VerifyMnemonicWord
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
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.VerifyMnemonicWordViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}

extension VerifyMnemonicWordView:TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender == myTagListView {
            myTagListView.removeTag(title)
            poolTagListView.addTag(title)
            if selectValues.contains(title) {
                let index = selectValues.index(of: title)
                selectValues.remove(at: index!)
            }
            tagView.tagBackgroundColor = UIColor.cornflowerBlueTwo
        } else if sender == poolTagListView {
            poolTagListView.removeTag(title)
            myTagListView.addTag(title)
            if !selectValues.contains(title) {
                selectValues.append(title)
            }
            tagView.tagBackgroundColor = UIColor.white
            self.next?.sendEventWith(Event.VerifyMnemonicWord.rawValue, userinfo: ["data":selectValues])
        }
    }
}

