//
//  StatusView.swift
//  EOS
//
//  Created by peng zhu on 2018/8/8.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class StatusView: UIView {

    @IBOutlet weak var bgView: CornerAndShadowView!

    @IBOutlet weak var leftLabel: UILabel!

    @IBOutlet weak var rightLabel: UILabel!

    var highlighted: Bool = false {
        didSet {
            updateContent()
        }
    }

    var selCount: Int = 0 {
        didSet {
            updateContent()
        }
    }

    func updateContent() {
        let vote = R.string.localizable.vote_title.key.localized()
        let unEnaough = R.string.localizable.vote_unenough.key.localized()
        leftLabel.text = String(format: "%d/30", selCount)
        leftLabel.backgroundColor = highlighted && selCount > 0 ? UIColor.baseLightColor : UIColor.unableLightColor
        rightLabel.backgroundColor = highlighted && selCount > 0 ? UIColor.baseColor : UIColor.unableColor
        rightLabel.text = highlighted ? vote : unEnaough
    }

    func setup() {
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        setup()
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
