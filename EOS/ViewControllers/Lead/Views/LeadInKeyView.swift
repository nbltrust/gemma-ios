//
//  LeadInKeyView.swift
//  EOS
//
//  Created by DKM on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import GrowingTextView
import GrowingTextView.Swift

class LeadInKeyView: UIView {
    enum EventName: String {
        case beginLeadInAction
    }
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textView: GrowingTextView!
    
    @IBOutlet weak var creatButton: Button!

    @IBOutlet weak var currencyView: CustomCellView!

    @IBOutlet weak var walletView: CustomCellView!

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    func setup() {
        self.textView.minHeight = 100
        self.textView.maxHeight = 100
        self.textView.font = UIFont.systemFont(ofSize: 16)
        self.textView.textColor = UIColor.baseColor
        self.textView.textContainerInset = UIEdgeInsets(top: 16, left: 15, bottom: 16, right: 15)
        self.creatButton.isEnabel.accept(false)

        currencyView.title = R.string.localizable.wallet_currency.key.localized()
        walletView.title = R.string.localizable.leadin_to_wallet.key.localized()

        creatButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.next?.sendEventWith(EventName.beginLeadInAction.rawValue, userinfo: ["data": ""])
        }).disposed(by: disposeBag)
    }

    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var buttonTitle = "" {
        didSet {
            creatButton.locali = buttonTitle
        }
    }

    func updateHeight() {
        layoutIfNeeded()
        self.height = dynamicHeight()
        invalidateIntrinsicContentSize()
    }

    fileprivate func dynamicHeight() -> CGFloat {
        let lastView = self.subviews.last?.subviews.last
        return lastView!.bottom
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
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

extension LeadInKeyView: GrowingTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trimmed == "" {
            self.creatButton.isEnabel.accept(false)
        } else {
            self.creatButton.isEnabel.accept(true)
        }
    }
}
