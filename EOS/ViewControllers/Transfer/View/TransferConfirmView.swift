//
//  TransferConfirmView.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation
import SwiftRichString

struct ConfirmViewModel {
    var recever = ""
    var amount = ""
    var remark = ""
    var payAccount = ""
    var buttonTitle = ""
}

@IBDesignable
class TransferConfirmView: UIView {
    @IBOutlet weak var receverView: LineView!

    @IBOutlet weak var amountView: LineView!

    @IBOutlet weak var remarkView: LineView!

    @IBOutlet weak var payAccountView: LineView!

    @IBOutlet weak var sureView: Button!

    @IBOutlet weak var bottomView: UIView!

    enum TransferEvent: String {
        case sureTransfer
    }

    var data: ConfirmViewModel! {
        didSet {
            if data.recever == "" {
                receverView.isHidden = true
            } else {
                receverView.contentText = "@" + data.recever
            }
            amountView.contentText = data.amount + " EOS"
            if data.remark == "" {
                data.remark = R.string.localizable.default_remark_pre.key.localized() + CurrencyManager.shared.getCurrentAccountName() + R.string.localizable.default_remark_after.key.localized()
            }
            if data.buttonTitle == R.string.localizable.check_transfer.key.localized() {
                remarkView.content.numberOfLines = 1
            } else {
                remarkView.content.numberOfLines = 0
            }
            if data.buttonTitle == R.string.localizable.confirm_sell.key.localized() {
                amountView.contentText = data.amount + " KB"
                amountView.nameText = R.string.localizable.amount.key.localized()
            }
            if data.buttonTitle == R.string.localizable.confirm_sell.key.localized() || data.buttonTitle == R.string.localizable.confirm_buy.key.localized() {
                remarkView.nameText = R.string.localizable.explain.key.localized()
            }

            remarkView.contentText = data.remark
            if data.payAccount == "" {
                bottomView.isHidden = true
            } else {
                bottomView.isHidden = false
                payAccountView.contentText = data.payAccount
            }
            sureView.title = data.buttonTitle
            updateHeight()
        }
    }

    func setUp() {
        setupUI()
        setupEvent()
        updateHeight()
        setRichText()
    }

    func setupUI() {
        receverView.nameStyle = LineViewStyleNames.confirmName.rawValue
        amountView.nameStyle = LineViewStyleNames.confirmName.rawValue
        remarkView.nameStyle = LineViewStyleNames.confirmName.rawValue
        payAccountView.nameStyle = LineViewStyleNames.confirmName.rawValue

        receverView.contentStyle = LineViewStyleNames.transferConfirm.rawValue
        amountView.contentStyle = LineViewStyleNames.transferConfirm.rawValue
        remarkView.contentStyle = LineViewStyleNames.normalName.rawValue
        payAccountView.contentStyle = LineViewStyleNames.transferConfirm.rawValue
    }

    func setRichText() {
        _ = Style {
            $0.font = SystemFonts.PingFangSC_Semibold.font(size: 16.0)
            $0.color = UIColor.baseColor
        }
        _ = Style {
            $0.font = SystemFonts.PingFangSC_Regular.font(size: 12.0)

        }
//        let myGroup = StyleGroup(["money": money,"eos" : eos])
//        let text = <money>amountView.contentText</money>  + " EOS"
//        amountView.contentText 
    }

    func setupEvent() {
        sureView.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(TransferEvent.sureTransfer.rawValue, userinfo: ["btntitle": self.sureView.title])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    fileprivate func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return (lastView?.frame.origin.y)! + (lastView?.frame.size.height)!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setUp()
    }

    fileprivate func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        guard let  view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
