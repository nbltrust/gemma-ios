//
//  ScreenShotAlertView.swift
//  EOS
//
//  Created by zhusongyu on 2018/7/18.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable
class ScreenShotAlertView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var knowButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!

    enum ScreenShotEvent: String {
        case sureShot
        case cancelShot
    }

    var tips = "" {
        didSet {
            tipsLabel.text = tips
        }
    }

    func setUp() {
        setUpUI()
        setupEvent()
        updateHeight()
    }

    func setUpUI() {
    }

    func setupEvent() {
        knowButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(ScreenShotEvent.sureShot.rawValue, userinfo: [ : ])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

        cancelButton.rx.controlEvent(.touchUpInside).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.sendEventWith(ScreenShotEvent.cancelShot.rawValue, userinfo: [ : ])
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize.init(width: UIView.noIntrinsicMetric, height: dynamicHeight())
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

                self.insertSubview(view, at: 0)

//        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
