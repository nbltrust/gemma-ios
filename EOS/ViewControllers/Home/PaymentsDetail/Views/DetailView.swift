//
//  DetailView.swift
//  EOS
//
//  Created by DKM on 2018/7/12.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift

class DetailView: UIView {
    enum EventName: String {
        case openSafair
    }

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var memo: UILabel!
    @IBOutlet weak var tradeNumber: UILabel!
    @IBOutlet weak var blcok: UILabel!
    @IBOutlet weak var stateIcon: UIImageView!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var people: UILabel!

    @IBOutlet weak var webLabel: UILabel!

    enum Event {
        case copy
    }

    var data: Any? {
        didSet {
            if let data = data as? PaymentsRecordsViewModel {

                address.text = data.address
                time.text = data.time
                state.text = data.transferState
                memo.text = data.memo
                tradeNumber.text = data.hashNumber
                blcok.text = "\(data.block)"
                stateIcon.image = data.stateImageName ==  R.image.icIncome() ? R.image.icIncomeWhite() : R.image.ic_income_white()
                money.text = data.money

                titleLabel.text = data.stateImageName ==  R.image.icIncome() ? R.string.localizable.receive.key.localized() : R.string.localizable.send.key.localized()
                people.text = data.stateImageName !=  R.image.icIncome() ? R.string.localizable.receiver.key.localized() : R.string.localizable.sender.key.localized()
            }
        }
    }

    func setup() {
        setupEvent()
        updateHeight()
        self.webLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSafair))

        self.webLabel.addGestureRecognizer(tap)
    }

    func setupEvent() {

    }

    @IBAction func copyButtonClick(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        if let data = data as? PaymentsRecordsViewModel {
            pasteboard.string = data.hash
            showSuccessTop(R.string.localizable.have_copied.key.localized())
        }
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
extension DetailView {
    @objc func openSafair() {
        self.next?.sendEventWith(EventName.openSafair.rawValue, userinfo: [:])
    }
}
