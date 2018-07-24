//
//  GestureLockView.swift
//  EOS
//
//  Created by peng zhu on 2018/7/16.
//  Copyright © 2018年 com.nbltrust. All rights reserved.
//

import UIKit

class GestureLockView: UIView {

    private var itemLayers: [GestureItemLayer] = []
    
    private var selectedItemLayers: [GestureItemLayer] = []
    
    private var mainPath = UIBezierPath()
    
    private var interval: TimeInterval = 0
    
    private(set) var password = ""
    
    private var lastLocation = CGPoint.zero
    
    private var shapeLayer: CAShapeLayer? {
        return layer as? CAShapeLayer
    }

    open var itemSizes: (width: CGFloat,gap: CGFloat,centerRadius: CGFloat) = (64,40,10) {
        didSet {
            setNeedsLayout()
        }
    }
    
    override open class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupLayer()
    }
    
    fileprivate func setupLayer() {
        self.shapeLayer?.lineCap = kCALineCapRound
        self.shapeLayer?.lineJoin = kCALineJoinRound
        self.shapeLayer?.fillColor = UIColor.clear.cgColor
        self.shapeLayer?.strokeColor = GestureLockSetting.lockHighlightedColor.cgColor
        self.shapeLayer?.lineWidth = GestureLockSetting.lockHighlightedBorderWidth
    }
    
    fileprivate func setupUI() {
        for _ in 0 ..< 9 {
            let itemLayer = GestureItemLayer()
            itemLayers.append(itemLayer)
            layer.addSublayer(itemLayer)
        }
    }
    
    public func showSelectedItems(_ passwordStr: String) {
        for char in passwordStr {
            itemLayers[Int("\(char)")!].status = .highlighted
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let marginX = (frame.width - itemSizes.width.adapt() * 3 - itemSizes.gap.adapt() * 2) / 2
        let marginY = (frame.height - itemSizes.width.adapt() * 3 - itemSizes.gap.adapt() * 2) / 2
        
        for (idx, sublayer) in itemLayers.enumerated() {
            let row = CGFloat(idx % 3)
            let col = CGFloat(idx / 3)
            let originX = (itemSizes.width.adapt() + itemSizes.gap.adapt()) * row + marginX
            let originY = (itemSizes.width.adapt() + itemSizes.gap.adapt()) * col + marginY
            sublayer.index = idx
            sublayer.centerRadio = itemSizes.centerRadius
            sublayer.width = itemSizes.width.adapt()
            sublayer.origin = CGPoint(x: originX, y: originY)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        processTouch(touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        processTouch(touches)
    }
    
    override open func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        touchesEnd()
    }
    
    override open func touchesCancelled(_: Set<UITouch>?, with _: UIEvent?) {
        touchesEnd()
    }
    
    private func processTouch(_ touches: Set<UITouch>) {
        let location = touches.first!.location(in: self)
        guard let itemLayer = itemLayer(with: location) else {
            return
        }
        if selectedItemLayers.contains(itemLayer) {
            return
        }
        selectedItemLayers.append(itemLayer)
        password += itemLayer.index.description
        itemLayer.status = .highlighted
        drawLine()
    }
    
    private func touchesEnd() {
        self.reset()
    }
    
    private func itemLayer(with touchLocation: CGPoint) -> GestureItemLayer? {
        for subLayer in itemLayers {
            if !subLayer.frame.contains(touchLocation) {
                continue
            }
            return subLayer
        }
        return nil
    }
    
    private func drawLine() {
        
        if selectedItemLayers.isEmpty { return }
        
        for (idx, itemlayer) in selectedItemLayers.enumerated() {
            let directPoint = itemlayer.position
            if idx == 0 {
                lastLocation = directPoint
                mainPath.move(to: directPoint)
            } else {
                itemlayer.dirAngle = angleBetweenLines(firstLineStart: lastLocation, firstLineEnd: directPoint, secondLineStart: lastLocation, secondLineEnd: CGPoint(x: lastLocation.x + 20, y: lastLocation.y))
                mainPath.addLine(to: directPoint)
                lastLocation = directPoint
            }
        }
        shapeLayer?.path = mainPath.cgPath
    }
    
    private func angleBetweenLines(firstLineStart: CGPoint,firstLineEnd: CGPoint,secondLineStart: CGPoint,secondLineEnd: CGPoint) -> Double {
        let a = firstLineEnd.x - firstLineStart.x
        let b = firstLineEnd.y - firstLineStart.y
        let c = secondLineEnd.x - secondLineStart.x
        let d = secondLineEnd.y - secondLineStart.y
        let rads = acos(((a * c) + (b * d)) / ((sqrt(a * a + b * b)) * (sqrt(c * c + d * d))))
        var growValue: Double = 0
        if (firstLineEnd.x > firstLineStart.x && firstLineEnd.y > firstLineStart.y) || (secondLineEnd.x > secondLineStart.x && secondLineEnd.y > secondLineStart.y) {
            growValue = 180
        }
        return (rads.double * 180) / Double.pi + growValue
    }
    
    public func warn() {
        interval = 1
        selectedItemLayers.forEach { $0.status = .warning }
        shapeLayer?.strokeColor = GestureLockSetting.warningColor.cgColor
    }
    
    public func reset() {
        interval = 0
        shapeLayer?.strokeColor = GestureLockSetting.lockHighlightedColor.cgColor
        selectedItemLayers.forEach { $0.status = .normal }
        selectedItemLayers.removeAll()
        mainPath.removeAllPoints()
        shapeLayer?.path = mainPath.cgPath
        password = ""
        drawLine()
    }

}
