//
//  ScanShadeView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

struct ScanSetting {
    static let scanMagin: CGFloat = 70.0
    static let scanWidth: CGFloat = (UIScreen.main.bounds.width - scanMagin) / 2
    static let scanRect: CGRect = CGRect(x: scanMagin, y: (UIScreen.main.bounds.height - scanMagin) / 2, width: scanWidth, height: scanWidth)
}

class ScanShadeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.black40.setFill()
        UIRectFill(rect)
        let previewRect = rect.intersection(ScanSetting.scanRect)
        UIColor.clear.setFill()
        UIRectFill(previewRect)
    }
}
