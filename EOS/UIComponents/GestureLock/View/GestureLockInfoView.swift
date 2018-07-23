//
//  GestureLockInfoView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class GestureLockInfoView: UIView {

    private var infoLayers: [GestureInfoItemLayer] = []
    
    open var itemSizes: (width: CGFloat,gap: CGFloat) = (10,5) {
        didSet {
            setNeedsLayout()
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        for _ in 0 ..< 9 {
            let itemLayer = GestureInfoItemLayer()
            infoLayers.append(itemLayer)
            layer.addSublayer(itemLayer)
        }
    }
    
    public func showSelectedItems(_ passwordStr: String) {
        for char in passwordStr {
            infoLayers[Int("\(char)")!].status = .highlighted
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let marginX = (frame.width - itemSizes.width * 3 - itemSizes.gap * 2) / 2
        let marginY = (frame.height - itemSizes.width * 3 - itemSizes.gap * 2) / 2
        
        for (idx, sublayer) in infoLayers.enumerated() {
            let row = CGFloat(idx % 3)
            let col = CGFloat(idx / 3)
            let originX = (itemSizes.width + itemSizes.gap) * row + marginX
            let originY = (itemSizes.width + itemSizes.gap) * col + marginY
            sublayer.index = idx
            sublayer.width = itemSizes.width
            sublayer.origin = CGPoint(x: originX, y: originY)
        }
    }

}
