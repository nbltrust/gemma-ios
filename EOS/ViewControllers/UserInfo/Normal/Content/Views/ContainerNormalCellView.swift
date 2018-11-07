//
//  ContainerNormalCellView.swift
//  EOS
//
//  Created by DKM on 2018/8/1.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit
import TinyConstraints

class ContainerNormalCellView: UIView {

    enum Event: String {
        case selectedSetting
    }

    @IBOutlet weak var stackView: UIStackView!

    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex != oldValue {
                if let oldView = self.stackView.viewWithTag(oldValue + 1) as? NormalCellView {
                    oldView.rightIconName = R.image.select.name
                }

                if let newView = self.stackView.viewWithTag(selectedIndex + 1) as? NormalCellView {
                    newView.rightIconName = R.image.group.name
                }
            }
        }
    }
    var data: Any? {
        didSet {
            if let data = data as? [String] {
                self.removeStackViewSubviews()
                for index in 0..<data.count {
                    let item = data[index]
                    let cellView = NormalCellView(frame: CGRect(x: 0, y: 0, width: self.stackView.width, height: 48))
                    cellView.index = index
                    cellView.nameText = item
                    cellView.state = 1
                    cellView.tag = (index + 1)
                    cellView.backgroundColor = UIColor.whiteColor
                    cellView.nameStyle = LineViewStyleNames.normalName.rawValue
                    cellView.rightIconName = index == self.selectedIndex ? R.image.group.name : R.image.select.name
                    if index == data.count - 1 {
                        cellView.isShowLineView = false
                    }
                    self.stackView.addArrangedSubview(cellView)
                    cellView.height(48)

                }
                self.layoutIfNeeded()
                updateHeight()
            }
        }
    }

    fileprivate func removeStackViewSubviews() {
        for subView in self.stackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        updateHeight()
    }

    func setup() {

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
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
extension ContainerNormalCellView {
    @objc func clickCellView(_ sender: [String: Any]) {
        if let index = sender["index"] as? Int {
            self.selectedIndex = index
            self.sendEventWith(Event.selectedSetting.rawValue, userinfo: ["index": index])
        }
    }
}
