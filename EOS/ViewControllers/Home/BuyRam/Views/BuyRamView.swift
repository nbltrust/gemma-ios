//
//  BuyRamView.swift
//  EOS
//
//  Created zhusongyu on 2018/8/9.
//  Copyright © 2018年 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class BuyRamView: UIView {

    @IBOutlet weak var generalRamView: GeneralRamCellView!
    @IBOutlet weak var pageView: PageView!
    @IBOutlet weak var leftNextButton: Button!
    @IBOutlet weak var rightNextButton: Button!
    @IBOutlet weak var exchangeLabelView: UIView!
    @IBOutlet weak var exchangeLabel: UILabel!

    enum Event: String {
        case leftnext
        case rightnext
        case left
        case right
    }

    var data: Any? {
        didSet {
            if let data = data as? BuyRamViewModel {
                generalRamView.data = data
                pageView.data = data
                if data.exchange == "" {
                    exchangeLabelView.isHidden = true
                } else {
                    exchangeLabel.text = data.exchange
                    exchangeLabelView.isHidden = false
                }
            }
        }
    }

    func setupUI() {
        generalRamView.generalView.name = R.string.localizable.ram.key.localized()
        generalRamView.generalView.leftSubText = R.string.localizable.use.key.localized() + " - " + R.string.localizable.ms.key.localized()
        generalRamView.generalView.rightSubText = R.string.localizable.total.key.localized() + " - " + R.string.localizable.ms.key.localized()
        generalRamView.generalView.eos = ""
        generalRamView.generalView.lineIsHidden = false
        generalRamView.priceLabel.text = "≈- EOS/KB"

        pageView.leftText = R.string.localizable.buy.key.localized()
        pageView.rightText = R.string.localizable.sell.key.localized()
        exchangeLabelView.isHidden = true

        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
    }

    func setupEvent() {
        leftNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(Event.leftnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        rightNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(Event.rightnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    fileprivate func setup() {
        pageView.operationNumber = 1
        setupUI()
        setupEvent()
        updateHeight()
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
        return lastView?.bottom ?? 0
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
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension BuyRamView {
    @objc func left(_ data: [String: Any]) {
        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
        self.next?.sendEventWith(Event.left.rawValue, userinfo: [:])
    }
    @objc func right(_ data: [String: Any]) {
        leftNextButton.isHidden = true
        rightNextButton.isHidden = false
        self.next?.sendEventWith(Event.right.rawValue, userinfo: [:])
    }
}
