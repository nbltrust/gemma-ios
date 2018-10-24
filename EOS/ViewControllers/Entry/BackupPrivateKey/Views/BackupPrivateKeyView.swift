//
//  BackupPrivateKeyView.swift
//  EOS
//
//  Created by zhusongyu on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

class BackupPrivateKeyView: UIView {

    @IBOutlet weak var knowButton: Button!
    @IBOutlet weak var redTipsLabel: BaseLabel!
    @IBOutlet weak var whiteTipOneLabel: BaseLabel!
    @IBOutlet weak var whiteTipTwoLabel: BaseLabel!

    enum Event: String {
        case know
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
    }

    func setupUI() {
        whiteTipOneLabel.text = R.string.localizable.backup_introduce_one.key.localized()
        whiteTipTwoLabel.text = R.string.localizable.backup_introduce_two.key.localized()
    }

    var redTips = "" {
        didSet {
            redTipsLabel.text = redTips
        }
    }

    var buttonTitle = "" {
        didSet {
            knowButton.title = buttonTitle
        }
    }

    func setup() {
        setupUI()
        knowButton.button.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.next?.sendEventWith(Event.know.rawValue, userinfo: ["data": ""])
        }).disposed(by: disposeBag)
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
