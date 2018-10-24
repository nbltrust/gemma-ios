//
//  AccountInfo.swift
//  EOS
//
//  Created by 朱宋宇 on 2018/7/6.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import Foundation

@IBDesignable

class AccountInfoView: UIView {

    @IBOutlet weak var cornerShadowView: CornerAndShadowView!
    @IBOutlet weak var mTotalEOSLabel: UILabel!
    @IBOutlet weak var mTotalCNYLabel: UILabel!
    @IBOutlet weak var mRemainEOSLabel: UILabel!
    @IBOutlet weak var mRedeemEOSLabel: UILabel!
    @IBOutlet weak var mCPUConsumeEOSLabel: UILabel!
    @IBOutlet weak var mNETConsumeEOSLabel: UILabel!
    @IBOutlet weak var mRAMConsumeKBLabel: UILabel!
    @IBOutlet weak var mHorLineView: DashLineView!
    @IBOutlet weak var mHorLineViewTwo: DashLineView!
    @IBOutlet weak var refundLabel: UILabel!
    @IBOutlet weak var backupLabel: UIView!

    @IBOutlet weak var cpuProgress: UIProgressView!
    @IBOutlet weak var netProgress: UIProgressView!
    @IBOutlet weak var ramProgress: UIProgressView!

    @IBOutlet weak var backupLabelView: UIView!
    @IBOutlet weak var refundView: UIView!

    @IBOutlet weak var cpuView: UIView!
    @IBOutlet weak var netView: UIView!
    @IBOutlet weak var ramView: UIView!

    enum tapEvent: String {
        case refundEvent
        case backupEvent
        case cpuevent
        case netevent
        case ramevent
    }

    var data: Any? {
        didSet {
            if let data = data as? AccountViewModel {
                mTotalEOSLabel.text = data.allAssets
                mTotalCNYLabel.text = data.CNY
                mRemainEOSLabel.text = data.balance
                mRedeemEOSLabel.text = data.recentRefundAsset
                mCPUConsumeEOSLabel.text = "CPU"
                mNETConsumeEOSLabel.text = "NET"
                mRAMConsumeKBLabel.text = "RAM"
                cpuProgress.progress = data.cpuProgress
                netProgress.progress = data.netProgress
                ramProgress.progress = data.ramProgress

                setProgressUI(progress: cpuProgress)
                setProgressUI(progress: netProgress)
                setProgressUI(progress: ramProgress)

                if data.refundTime == "" {
                    refundView.isHidden = true
                } else {
                    refundView.isHidden = false
                    refundLabel.text = data.refundTime
                }
                updateHeight()
            }
        }
    }

    var backupLabelViewIsHidden = true {
        didSet {
            if backupLabelViewIsHidden == true {
                backupLabelView.isHidden = true
            } else {
                backupLabelView.isHidden = false
            }
        }
    }

    func setUp() {
//        backupLabelView.isHidden = true
//        refundView.isHidden = true
        setUpEvent()
    }

    func setProgressUI(progress: UIProgressView) {
        if progress.progress >= 0.85 {
            progress.tintColor = UIColor.scarlet
            progress.backgroundColor = UIColor.scarlet
        } else {
            progress.tintColor = UIColor.darkSkyBlueTwo
            progress.backgroundColor = UIColor.darkSkyBlueTwo
        }
    }

    func setUpEvent() {
        backupLabel.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            self.backupLabel.next?.sendEventWith(tapEvent.backupEvent.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)

        cpuView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            self.cpuView.next?.sendEventWith(tapEvent.cpuevent.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)

        netView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            self.cpuView.next?.sendEventWith(tapEvent.netevent.rawValue, userinfo: [:])
        }).disposed(by: disposeBag)

        ramView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] (_) in
            guard let `self` = self else { return }
            self.cpuView.next?.sendEventWith(tapEvent.ramevent.rawValue, userinfo: [:])
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
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
