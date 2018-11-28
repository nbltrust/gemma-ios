//
//  WalletItemView.swift
//  EOS
//
//  Created peng zhu on 2018/11/14.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class WalletItemView: BaseView {
    @IBOutlet weak var selectView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var moreView: UIImageView!

    @IBOutlet weak var logoView: UIImageView!

    @IBOutlet weak var desLabel: UILabel!

    @IBOutlet weak var lineLabel: UIView!

    enum Event:String {
        case moreViewDidClicked
    }

    override func setup() {
        super.setup()
        
        setupUI()
        setupSubViewEvent()
    }
    
    func setupUI() {
        
    }
    
    func setupSubViewEvent() {
//        moreView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
//            guard let `self` = self else { return }
//            self.next?.sendEventWith(Event.moreViewDidClicked.rawValue, userinfo: <#T##[String : Any]#>)
//        }).disposed(by: disposeBag)
    }
}
