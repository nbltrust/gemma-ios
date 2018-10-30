//
//  PageView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/25.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable
class PageView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftView: OperationLeftView!
    @IBOutlet weak var rightView: OperationRightView!

    var data: Any? {
        didSet {
            if let data = data as? PageViewModel {
                balance = R.string.localizable.balance_pre.key.localized() + data.balance
                leftLabel.text = data.leftText
                rightLabel.text = data.rightText
                leftView.data = data.operationLeft
                rightView.data = data.operationRight
            }
            if let data = data as? BuyRamViewModel {
                leftView.data = data
                rightView.data = data
            }

            updateHeight()
        }
    }

    enum Event: String {
        case left
        case right
    }

    enum Page: Int {
        case left = 0
        case right = 1
    }

    var index = Page.left

    @IBInspectable
    var leftText: String = "" {
        didSet {
            leftLabel.text = leftText
        }
    }

    @IBInspectable
    var rightText: String = "" {
        didSet {
            rightLabel.text = rightText
        }
    }

    @IBInspectable
    var balance: String = "" {
        didSet {
            balanceLabel.text = balance
        }
    }

    var operationNumber = 2 {
        didSet {
            setUp()
            leftView.cpuMortgageView.reloadData()
            rightView.cpuMortgageCancelView.reloadData()
        }
    }

    func setUp() {
        if operationNumber == 1 {
            leftView.isHiddenBottomView = true
            rightView.isHiddenBottomView = true
        }
        updateLabelStatus()
        setupEvent()
        updateHeight()
    }

    func updateLabelStatus() {
        if index == Page.left {
            leftLabel.textColor = UIColor.baseColor
            rightLabel.textColor = UIColor.subTitleColor
        } else {
            leftLabel.textColor = UIColor.subTitleColor
            rightLabel.textColor = UIColor.baseColor
        }
    }

    func setupEvent() {
        leftLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.leftLabel.next?.sendEventWith(Event.left.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)

        rightLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.rightLabel.next?.sendEventWith(Event.right.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)
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

//                self.insertSubview(view, at: 0)

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension PageView {
    @objc func left(_ data: [String: Any]) {
        lineView.centerX = leftLabel.centerX
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        index = Page.left
        updateLabelStatus()
        self.next?.sendEventWith(Event.left.rawValue, userinfo: [:])
    }
    @objc func right(_ data: [String: Any]) {
        lineView.centerX = rightLabel.centerX
        scrollView.setContentOffset(CGPoint(x: self.width, y: 0), animated: true)
        index = Page.right
        updateLabelStatus()
        self.next?.sendEventWith(Event.right.rawValue, userinfo: [:])
    }
}
