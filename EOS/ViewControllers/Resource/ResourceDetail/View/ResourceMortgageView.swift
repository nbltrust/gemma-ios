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
    @IBOutlet weak var ramView: GeneralCellView!
    @IBOutlet weak var delegateView: LineView!
    @IBOutlet weak var buyRamView: LineView!

    enum Event: String {
        case delegateViewDidClicked
        case buyRamViewDidClicked
    }

    var data: Any? {
        didSet {
            if let data = data as? ResourceViewModel {
                cpuView.data = data.general[0]
                netView.data = data.general[1]
                ramView.data = data.general[2]
                ramView.eosLabel.isHidden = true
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
        self.delegateView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.next?.sendEventWith(Event.delegateViewDidClicked.rawValue, userinfo: ["data": self.data ?? []])
        }).disposed(by: disposeBag)
        self.buyRamView.rx.tapGesture().when(.recognized).subscribe(onNext: {[weak self] _ in
            guard let `self` = self else { return }
            self.next?.sendEventWith(Event.buyRamViewDidClicked.rawValue, userinfo: ["data": self.data ?? []])
        }).disposed(by: disposeBag)
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
        netView.lineIsHidden = false

        ramView.name = R.string.localizable.net()
        ramView.leftSubText = R.string.localizable.use.key.localized() + " - " + R.string.localizable.kb.key.localized()
        ramView.rightSubText = R.string.localizable.total.key.localized() + " - " + R.string.localizable.kb.key.localized()
//        netView.eos = "- EOS"
        ramView.lineIsHidden = false

        delegateView.data = LineView.LineViewModel.init(name: R.string.localizable.delegate_redeem.key.localized(),
                                                        content: R.string.localizable.manager_cpu_net.key.localized(),
                                                        imageName: R.image.icTabArrow.name,
                                                        nameStyle: LineViewStyleNames.normalName,
                                                        contentStyle: LineViewStyleNames.normalContent,
                                                        isBadge: false,
                                                        contentLineNumber: 1,
                                                        isShowLineView: true)
        buyRamView.data = LineView.LineViewModel.init(name: R.string.localizable.deal_ram.key.localized(),
                                                        content: "",
                                                        imageName: R.image.icTabArrow.name,
                                                        nameStyle: LineViewStyleNames.normalName,
                                                        contentStyle: LineViewStyleNames.normalContent,
                                                        isBadge: false,
                                                        contentLineNumber: 1,
                                                        isShowLineView: true)
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

        //        self.insertSubview(view, at: 0)

        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
