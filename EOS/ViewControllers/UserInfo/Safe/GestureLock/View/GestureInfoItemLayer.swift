//
//  GestureInfoItemLayer.swift
//  EOS
//
//  Created by peng zhu on 2018/7/19.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

enum GestureInfoItemStatus: Int {
    case normal = 1
    case highlighted
}

class GestureInfoItemLayer: CAShapeLayer {

    var status: GestureInfoItemStatus = .normal {
        didSet {
            setupStatus()
        }
    }

    var width: CGFloat = 0 {
        didSet {
            frame.size = CGSize(width: width, height: width)
            self.cornerRadius = width / 2
        }
    }

    var index: Int = 0

    var origin: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            frame.origin = origin
        }
    }

    override init() {
        super.init()
        setupStatus()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setupStatus()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
        setupStatus()
    }

    func reset() {
        status = .normal
    }

    func setupStatus() {
        if status == .normal {
            self.turnNormal()
        } else {
            self.turnHighlighted()
        }
    }

    fileprivate func turnNormal() {
        self.borderColor = GestureLockSetting.infoNormalColor.cgColor
        self.borderWidth = GestureLockSetting.infoNormalBorderWidth
        self.backgroundColor = UIColor.clear.cgColor
    }

    fileprivate func turnHighlighted() {
        self.backgroundColor = GestureLockSetting.infoHighlightedColor.cgColor
        self.borderColor = GestureLockSetting.infoHighlightedColor.cgColor
    }
}
