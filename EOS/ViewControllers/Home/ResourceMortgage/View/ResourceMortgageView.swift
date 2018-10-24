//
//  ResourceMortgageView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/24.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class ResourceMortgageView: UIView {

    @IBOutlet weak var cpuView: GeneralCellView!
    @IBOutlet weak var netView: GeneralCellView!
    @IBOutlet weak var pageView: PageView!
    @IBOutlet weak var cornerShadowView: CornerAndShadowView!
    @IBOutlet weak var leftNextButton: Button!
    @IBOutlet weak var rightNextButton: Button!

    enum event: String {
        case leftnext
        case rightnext
    }

    var data: Any? {
        didSet {
            if let data = data as? ResourceViewModel {
                cpuView.data = data.general[0]
                netView.data = data.general[1]
                pageView.data = data.page
                updateHeight()
            }
        }
    }

    func setUp() {
        setupUI()
        setupEvent()
        updateHeight()
    }

    func setupEvent() {
        leftNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
//            self.pageView.leftView.cpuMortgageView.resignFirstResponder()
            self.sendEventWith(event.leftnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        rightNextButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.endEditing(true)
            self.sendEventWith(event.rightnext.rawValue, userinfo: [:])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    func setupUI() {
        cpuView.name = R.string.localizable.cpu.key.localized()
        cpuView.leftSubText = R.string.localizable.use.key.localized() + " - " + R.string.localizable.ms.key.localized()
        cpuView.rightSubText = R.string.localizable.total.key.localized() + " - " + R.string.localizable.ms.key.localized()
        cpuView.eos = "- EOS"
        cpuView.lineIsHidden = false

        netView.name = R.string.localizable.net()
        netView.leftSubText = R.string.localizable.use.key.localized() + " - " + R.string.localizable.kb.key.localized()
        netView.rightSubText = R.string.localizable.total.key.localized() + " - " + R.string.localizable.kb.key.localized()
        netView.eos = "- EOS"
        netView.lineIsHidden = true

        pageView.leftText = R.string.localizable.mortgage_resource.key.localized()
        pageView.rightText = R.string.localizable.cancel_mortgage.key.localized()
        pageView.balance = R.string.localizable.balance_pre.key.localized() + "- EOS"

        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        //        self.insertSubview(view, at: 0)

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

extension ResourceMortgageView {
    @objc func left(_ data: [String: Any]) {
        leftNextButton.isHidden = false
        rightNextButton.isHidden = true
    }
    @objc func right(_ data: [String: Any]) {
        leftNextButton.isHidden = true
        rightNextButton.isHidden = false
    }
}
