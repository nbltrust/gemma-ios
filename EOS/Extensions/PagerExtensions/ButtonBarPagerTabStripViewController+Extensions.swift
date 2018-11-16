//
//  ButtonBarPagerTabStripViewController+Extensions.swift
//  EOS
//
//  Created by peng zhu on 2018/10/31.
//  Copyright © 2018 com.nbltrustdev. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import XLPagerTabStrip.Swift

extension ButtonBarPagerTabStripViewController {
    func addGapView() {
        let left = self.settings.style.buttonBarLeftContentInset ?? 0
        let right = self.settings.style.buttonBarRightContentInset ?? 0
        let width = self.buttonBarView.width - left - right
        let oraginY = self.buttonBarView.height - 0.5
        let gapView = UIView.init(frame: CGRect(x: left, y: oraginY, width: width, height: 0.5))
        gapView.backgroundColor = UIColor.separatorColor
        self.buttonBarView.superview?.addSubview(gapView)
        self.buttonBarView.superview?.bringSubviewToFront(gapView)
//        self.buttonBarView.sendSubviewToBack(gapView)
    }
}
