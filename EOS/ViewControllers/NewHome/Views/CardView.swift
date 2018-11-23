//
//  CardView.swift
//  EOS
//
//  Created zhusongyu on 2018/10/16.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation

@IBDesignable
class CardView: UIView {

    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var currencyImgView: UIImageView!
    @IBOutlet weak var currencyLabel: BaseLabel!
    @IBOutlet weak var accountLabel: BaseLabel!
    @IBOutlet weak var balanceLabel: BaseLabel!
    @IBOutlet weak var tokenLabel: BaseLabel!
    @IBOutlet weak var otherBalanceLabel: BaseLabel!
    @IBOutlet weak var shadeView: UIView!
    @IBOutlet weak var shadeLabel: BaseLabel!
    @IBOutlet weak var tokenView: UIView!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var refundView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var useBalanceLabel: BaseLabel!
    @IBOutlet weak var useBalanceNameLabel: BaseLabel!
    @IBOutlet weak var redundNameLabel: BaseLabel!
    @IBOutlet weak var refundLabel: BaseLabel!
    @IBOutlet weak var cpuProgress: UIProgressView!
    @IBOutlet weak var netProgress: UIProgressView!
    @IBOutlet weak var ramProgress: UIProgressView!
    
    var tokenArray: [String] = [] {
        didSet {
            self.tokenView.removeSubviews()
            for index in 0..<tokenArray.count {
                if index < 5 {
                    let imgView = UIImageView(frame: CGRect(x: 88 - (index+1)*28 + index*13, y: 0, width: 28, height: 28))
                    imgView.kf.setImage(with: URL(string: tokenArray[index]), placeholder: R.image.icTokenUnknown())
                    imgView.layer.cornerRadius = 14
                    imgView.clipsToBounds = true
                    self.tokenView.insertSubview(imgView, at: 0)
                }
            }
            updateHeight()
        }
    }

    enum Event: String {
        case cardViewDidClicked
        case progressViewDidClicked
    }

    func setup() {

        setupUI()
        setupSubViewEvent()
    }

    func setProgressUI(progress: UIProgressView) {
        if progress.progress >= 0.85 {
            progress.tintColor = UIColor.warningColor
            progress.backgroundColor = UIColor.warningColor
        } else {
            progress.tintColor = UIColor.baseColor
            progress.backgroundColor = UIColor.baseColor
        }
    }
    
    func setupUI() {
        useBalanceNameLabel.text = R.string.localizable.useage_balance.key.localized()
        redundNameLabel.text = R.string.localizable.refund.key.localized()
    }

    func setupSubViewEvent() {
        progressView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
                self.progressView.next?.sendEventWith(Event.progressViewDidClicked.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric,height: dynamicHeight())
    }

    func updateHeight() {
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
