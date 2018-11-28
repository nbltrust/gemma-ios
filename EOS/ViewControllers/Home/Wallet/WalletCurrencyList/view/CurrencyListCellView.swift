//
//  CurrencyListCellView.swift
//  EOS
//
//  Created zhusongyu on 2018/11/27.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CurrencyListCellView: EOSBaseView {
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var titleLabel: BaseLabel!

    enum Event:String {
        case currencyListCellViewDidClicked
    }

    override var data: Any? {
        didSet {
        }
    }
    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
    
    }
    
    @objc override func didClicked() {
        self.next?.sendEventWith(Event.currencyListCellViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
