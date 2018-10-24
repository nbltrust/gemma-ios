//
//  CardView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CardView: EOSBaseView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var currencyLabel: BaseLabel!
    @IBOutlet weak var accountLabel: BaseLabel!
    @IBOutlet weak var balanceLabel: BaseLabel!
    @IBOutlet weak var unitLabel: BaseLabel!
    @IBOutlet weak var tokenLabel: BaseLabel!
    @IBOutlet weak var otherBalanceLabel: BaseLabel!
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var shadeLabel: BaseLabel!
    @IBOutlet weak var tokenView: UIView!

    var tokenArray: [String] = [] {
        didSet {
            if tokenArray.count < 6 {
                shadeView.isHidden = true
            } else {
                shadeLabel.text = "+\(tokenArray.count)"
            }

            for index in 0..<tokenArray.count {
                let imgView = UIImageView(frame: CGRect(x: 88 - (index+1)*28 + index*13, y: 0, width: 28, height: 28))
//                imgView.kf.setImage(with: URL(string: tokenArray[i]))
                imgView.image = R.image.eosBg()!
                self.tokenView.insertSubview(imgView, at: 0)
            }
        }
    }

    enum Event: String {
        case cardViewDidClicked
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
        self.next?.sendEventWith(Event.cardViewDidClicked.rawValue, userinfo: ["data": self.data ?? "", "self": self])
    }
}
